UPDATE media
SET STATUS = 'OUTDATED'
WHERE MEDIA_TYPE = 'application/epub+zip';

-- PostgreSQL equivalent of SQLite's COLLATE NOCASE
UPDATE media
SET STATUS = 'OUTDATED'
WHERE BOOK_ID IN (
    SELECT ID
    FROM BOOK
    WHERE LOWER(URL) LIKE '%.epub'
);
