CREATE TABLE SYNC_POINT
(
    ID           text      NOT NULL PRIMARY KEY,
    CREATED_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    USER_ID      text      NOT NULL,
    API_KEY_ID   text      NULL,
    FOREIGN KEY (USER_ID) REFERENCES "user" (ID)
);

CREATE INDEX IF NOT EXISTS idx__sync_point__user_id ON SYNC_POINT (USER_ID);

CREATE TABLE SYNC_POINT_BOOK_REMOVED_SYNCED
(
    SYNC_POINT_ID text NOT NULL,
    BOOK_ID       text NOT NULL,
    PRIMARY KEY (SYNC_POINT_ID, BOOK_ID),
    FOREIGN KEY (SYNC_POINT_ID) REFERENCES SYNC_POINT (ID)
);

CREATE INDEX IF NOT EXISTS idx__sync_point_book_removed_status__sync_point_id
    ON SYNC_POINT_BOOK_REMOVED_SYNCED (SYNC_POINT_ID);

CREATE TABLE SYNC_POINT_BOOK
(
    SYNC_POINT_ID                         text      NOT NULL,
    BOOK_ID                               text      NOT NULL,
    BOOK_CREATED_DATE                     timestamp NOT NULL,
    BOOK_LAST_MODIFIED_DATE               timestamp NOT NULL,
    BOOK_FILE_LAST_MODIFIED               timestamp NOT NULL,
    BOOK_FILE_SIZE                        bigint    NOT NULL,
    BOOK_FILE_HASH                        text      NOT NULL,
    BOOK_METADATA_LAST_MODIFIED_DATE      timestamp NOT NULL,
    BOOK_READ_PROGRESS_LAST_MODIFIED_DATE timestamp NULL,
    SYNCED                                boolean   NOT NULL DEFAULT FALSE,
    PRIMARY KEY (SYNC_POINT_ID, BOOK_ID),
    FOREIGN KEY (SYNC_POINT_ID) REFERENCES SYNC_POINT (ID)
);

CREATE INDEX IF NOT EXISTS idx__sync_point_book__sync_point_id ON SYNC_POINT_BOOK (SYNC_POINT_ID);
