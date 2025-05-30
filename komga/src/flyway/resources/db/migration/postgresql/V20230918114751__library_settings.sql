-- Rename column back and set default
ALTER TABLE LIBRARY
    RENAME COLUMN _UNUSED TO SCAN_STARTUP;

-- Note: PostgreSQL doesn't support placeholders like ${library-scan-startup} in DDL
-- You'll need to replace this with actual values
UPDATE LIBRARY
SET SCAN_STARTUP = FALSE;  -- Replace with actual default value

ALTER TABLE LIBRARY
    ADD COLUMN SCAN_CBX boolean NOT NULL DEFAULT TRUE;

ALTER TABLE LIBRARY
    ADD COLUMN SCAN_PDF boolean NOT NULL DEFAULT TRUE;

ALTER TABLE LIBRARY
    ADD COLUMN SCAN_EPUB boolean NOT NULL DEFAULT TRUE;

ALTER TABLE LIBRARY
    ADD COLUMN SCAN_INTERVAL text NOT NULL DEFAULT 'EVERY_6H';
