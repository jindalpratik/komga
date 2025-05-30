-- Note: PostgreSQL doesn't support placeholders like ${library-file-hashing} in DDL
-- You'll need to replace this with actual values or handle it in your application
ALTER TABLE library
    ADD COLUMN HASH_FILES boolean NOT NULL DEFAULT TRUE;  -- Replace with actual default

ALTER TABLE library
    ADD COLUMN HASH_PAGES boolean NOT NULL DEFAULT FALSE;

ALTER TABLE library
    ADD COLUMN ANALYZE_DIMENSIONS boolean NOT NULL DEFAULT TRUE;
