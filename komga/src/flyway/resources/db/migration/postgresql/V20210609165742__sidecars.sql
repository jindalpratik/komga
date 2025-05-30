CREATE TABLE SIDECAR
(
    URL                text      NOT NULL PRIMARY KEY,
    PARENT_URL         text      NOT NULL,
    LAST_MODIFIED_TIME timestamp NOT NULL,
    LIBRARY_ID         text      NOT NULL,
    FOREIGN KEY (LIBRARY_ID) REFERENCES LIBRARY (ID)
);

-- Add indexes for performance
CREATE INDEX idx_sidecar_parent_url ON SIDECAR(PARENT_URL);
CREATE INDEX idx_sidecar_library_id ON SIDECAR(LIBRARY_ID);
CREATE INDEX idx_sidecar_last_modified ON SIDECAR(LAST_MODIFIED_TIME);
