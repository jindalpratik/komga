-- This is a multi-steps migration, mixing 2 SQL migrations and a Java migration in-between

CREATE TABLE THUMBNAIL_BOOK
(
    ID                 text      NOT NULL PRIMARY KEY,
    THUMBNAIL          bytea     NULL,
    URL                text      NULL,
    SELECTED           boolean   NOT NULL DEFAULT FALSE,
    TYPE               text      NOT NULL,
    CREATED_DATE       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    LAST_MODIFIED_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    BOOK_ID            text      NOT NULL,
    FOREIGN KEY (BOOK_ID) REFERENCES BOOK (ID)
);

-- Create index for better performance on foreign key
CREATE INDEX idx_thumbnail_book_book_id ON THUMBNAIL_BOOK(BOOK_ID);

-- Create index for thumbnail selection queries
CREATE INDEX idx_thumbnail_book_selected ON THUMBNAIL_BOOK(BOOK_ID, SELECTED);
