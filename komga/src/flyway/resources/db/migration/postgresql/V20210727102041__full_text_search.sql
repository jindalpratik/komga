-- PostgreSQL uses different FTS approach than SQLite
-- Create GIN indexes for full-text search instead of virtual tables

-- Add tsvector columns for full-text search
ALTER TABLE book_metadata ADD COLUMN search_vector tsvector;
ALTER TABLE series_metadata ADD COLUMN search_vector tsvector;
ALTER TABLE collection ADD COLUMN search_vector tsvector;
ALTER TABLE readlist ADD COLUMN search_vector tsvector;
ALTER TABLE book_metadata_aggregation_author ADD COLUMN search_vector tsvector;

-- Create functions to update search vectors
CREATE OR REPLACE FUNCTION update_book_metadata_search_vector() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.title, '') || ' ' || COALESCE(NEW.isbn, ''));
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_series_metadata_search_vector() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.title, '') || ' ' || COALESCE(NEW.publisher, ''));
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_collection_search_vector() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.name, ''));
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_readlist_search_vector() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.name, ''));
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_aggregation_author_search_vector() RETURNS trigger AS $$
BEGIN
    NEW.search_vector := to_tsvector('english', COALESCE(NEW.name, ''));
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
CREATE TRIGGER book_metadata_search_vector_update
    BEFORE INSERT OR UPDATE ON book_metadata
                         FOR EACH ROW EXECUTE FUNCTION update_book_metadata_search_vector();

CREATE TRIGGER series_metadata_search_vector_update
    BEFORE INSERT OR UPDATE ON series_metadata
                         FOR EACH ROW EXECUTE FUNCTION update_series_metadata_search_vector();

CREATE TRIGGER collection_search_vector_update
    BEFORE INSERT OR UPDATE ON collection
                         FOR EACH ROW EXECUTE FUNCTION update_collection_search_vector();

CREATE TRIGGER readlist_search_vector_update
    BEFORE INSERT OR UPDATE ON readlist
                         FOR EACH ROW EXECUTE FUNCTION update_readlist_search_vector();

CREATE TRIGGER aggregation_author_search_vector_update
    BEFORE INSERT OR UPDATE ON book_metadata_aggregation_author
                         FOR EACH ROW EXECUTE FUNCTION update_aggregation_author_search_vector();

-- Update existing data
UPDATE book_metadata SET search_vector = to_tsvector('english', COALESCE(title, '') || ' ' || COALESCE(isbn, ''));
UPDATE series_metadata SET search_vector = to_tsvector('english', COALESCE(title, '') || ' ' || COALESCE(publisher, ''));
UPDATE collection SET search_vector = to_tsvector('english', COALESCE(name, ''));
UPDATE readlist SET search_vector = to_tsvector('english', COALESCE(name, ''));
UPDATE book_metadata_aggregation_author SET search_vector = to_tsvector('english', COALESCE(name, ''));

-- Create GIN indexes for fast full-text search
CREATE INDEX idx_book_metadata_search ON book_metadata USING GIN(search_vector);
CREATE INDEX idx_series_metadata_search ON series_metadata USING GIN(search_vector);
CREATE INDEX idx_collection_search ON collection USING GIN(search_vector);
CREATE INDEX idx_readlist_search ON readlist USING GIN(search_vector);
CREATE INDEX idx_aggregation_author_search ON book_metadata_aggregation_author USING GIN(search_vector);
