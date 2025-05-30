CREATE TABLE THUMBNAIL_SERIES
(
    ID                 text      NOT NULL PRIMARY KEY,
    URL                text      NOT NULL,
    SELECTED           boolean   NOT NULL DEFAULT FALSE,
    CREATED_DATE       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    LAST_MODIFIED_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    SERIES_ID          text      NOT NULL,
    FOREIGN KEY (SERIES_ID) REFERENCES SERIES (ID)
);

-- Create index for better performance on foreign key
CREATE INDEX idx_thumbnail_series_series_id ON THUMBNAIL_SERIES(SERIES_ID);

-- Create index for thumbnail selection queries
CREATE INDEX idx_thumbnail_series_selected ON THUMBNAIL_SERIES(SERIES_ID, SELECTED);
