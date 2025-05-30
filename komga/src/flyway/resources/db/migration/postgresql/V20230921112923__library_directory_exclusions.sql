CREATE TABLE LIBRARY_EXCLUSIONS
(
    LIBRARY_ID text NOT NULL,
    EXCLUSION  text NOT NULL,
    PRIMARY KEY (LIBRARY_ID, EXCLUSION),
    FOREIGN KEY (LIBRARY_ID) REFERENCES LIBRARY (ID)
);

CREATE INDEX idx__library_exclusions__library_id ON LIBRARY_EXCLUSIONS (LIBRARY_ID);

-- Insert default exclusions for all libraries
INSERT INTO LIBRARY_EXCLUSIONS
WITH cte_exclusions(exclude) AS (
    VALUES ('#recycle'),
           ('@eaDir'),
           ('@Recycle')
)
SELECT LIBRARY.ID, cte_exclusions.exclude
FROM LIBRARY
         CROSS JOIN cte_exclusions;
