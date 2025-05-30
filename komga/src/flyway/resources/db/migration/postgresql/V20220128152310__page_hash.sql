CREATE TABLE PAGE_HASH
(
    HASH               text      NOT NULL,
    MEDIA_TYPE         text      NOT NULL,
    SIZE               bigint    NULL,
    ACTION             text      NOT NULL,
    DELETE_COUNT       integer   NOT NULL DEFAULT 0,
    CREATED_DATE       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    LAST_MODIFIED_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (HASH, MEDIA_TYPE, SIZE)
);

CREATE TABLE PAGE_HASH_THUMBNAIL
(
    HASH       text   NOT NULL,
    MEDIA_TYPE text   NOT NULL,
    SIZE       bigint NULL,
    THUMBNAIL  bytea  NOT NULL,
    PRIMARY KEY (HASH, MEDIA_TYPE, SIZE)
);

-- Update MEDIA_PAGE file hashes
UPDATE MEDIA_PAGE
SET FILE_HASH = ''
WHERE BOOK_ID IN (
    SELECT DISTINCT m.BOOK_ID
    FROM MEDIA m
             LEFT JOIN MEDIA_PAGE MP ON m.BOOK_ID = MP.BOOK_ID
    WHERE mp.FILE_HASH <> ''
      AND m.MEDIA_TYPE <> 'application/zip'
);
