-- Drop the search vector columns and related objects
DROP TRIGGER IF EXISTS book_metadata_search_vector_update ON book_metadata;
DROP TRIGGER IF EXISTS series_metadata_search_vector_update ON series_metadata;
DROP TRIGGER IF EXISTS collection_search_vector_update ON collection;
DROP TRIGGER IF EXISTS readlist_search_vector_update ON readlist;
DROP TRIGGER IF EXISTS aggregation_author_search_vector_update ON book_metadata_aggregation_author;

DROP FUNCTION IF EXISTS update_book_metadata_search_vector();
DROP FUNCTION IF EXISTS update_series_metadata_search_vector();
DROP FUNCTION IF EXISTS update_collection_search_vector();
DROP FUNCTION IF EXISTS update_readlist_search_vector();
DROP FUNCTION IF EXISTS update_aggregation_author_search_vector();

ALTER TABLE book_metadata DROP COLUMN IF EXISTS search_vector;
ALTER TABLE series_metadata DROP COLUMN IF EXISTS search_vector;
ALTER TABLE collection DROP COLUMN IF EXISTS search_vector;
ALTER TABLE readlist DROP COLUMN IF EXISTS search_vector;
ALTER TABLE book_metadata_aggregation_author DROP COLUMN IF EXISTS search_vector;
