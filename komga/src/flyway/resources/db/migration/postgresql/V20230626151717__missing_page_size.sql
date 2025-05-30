UPDATE media
SET STATUS = 'OUTDATED'
WHERE BOOK_ID IN (
    SELECT DISTINCT M.BOOK_ID
    FROM MEDIA_PAGE P
             INNER JOIN MEDIA M ON P.BOOK_ID = M.BOOK_ID
    WHERE M.MEDIA_TYPE IN ('application/zip', 'application/x-rar-compressed; version=4')
      AND P.FILE_SIZE IS NULL
);
