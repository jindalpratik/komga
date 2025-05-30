CREATE TABLE BOOK_METADATA_LINK
(
    LABEL   text NOT NULL,
    URL     text NOT NULL,
    BOOK_ID text NOT NULL,
    FOREIGN KEY (BOOK_ID) REFERENCES BOOK (ID)
);

ALTER TABLE book_metadata
    ADD COLUMN LINKS_LOCK boolean NOT NULL DEFAULT FALSE;

-- Add index for performance
CREATE INDEX idx_book_metadata_link_book_id ON BOOK_METADATA_LINK(BOOK_ID);
