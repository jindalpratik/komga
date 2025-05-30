-- PostgreSQL can add columns directly without recreating the table
-- Add the missing columns that were removed in the table recreation

ALTER TABLE BOOK_METADATA
    ADD COLUMN IF NOT EXISTS TAGS_LOCK boolean NOT NULL DEFAULT FALSE;

-- If you need to remove columns that existed in the old table but not in the new one,
-- you can drop them directly (PostgreSQL advantage over SQLite)
-- Example: ALTER TABLE BOOK_METADATA DROP COLUMN IF EXISTS old_column_name;
