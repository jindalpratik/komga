-- Fix media type for files analyzed with tika 1.23 or before which didn't get the rar version
UPDATE MEDIA
SET MEDIA_TYPE = 'application/x-rar-compressed; version=4'
WHERE MEDIA_TYPE = 'application/x-rar-compressed'
  AND STATUS = 'READY';

-- Rar files that could have had an incorrect analysis are marked as OUTDATED to be re-analyzed
UPDATE MEDIA
SET STATUS = 'OUTDATED'
WHERE BOOK_ID IN (
    SELECT F.BOOK_ID
    FROM MEDIA_FILE F
             LEFT JOIN MEDIA M ON F.BOOK_ID = M.BOOK_ID
    WHERE F.FILE_NAME LIKE '%.%'
      AND M.MEDIA_TYPE LIKE 'application/x-rar-compressed%'
      AND lower(substring(F.FILE_NAME FROM '\.([^.]*)$'))
        IN ('jpg', 'jpeg', 'webp', 'tiff', 'tif', 'gif', 'png', 'bmp')
);
