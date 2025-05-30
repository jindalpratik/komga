-- Enable pgcrypto extension for cryptographic functions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE SERVER_SETTINGS
(
    KEY   text NOT NULL PRIMARY KEY,
    VALUE text NULL
);

-- Note: PostgreSQL doesn't support placeholders like ${delete-empty-collections} in DDL
-- You'll need to replace these with actual values
INSERT INTO SERVER_SETTINGS
VALUES ('DELETE_EMPTY_COLLECTIONS', 'true');  -- Replace with actual default

INSERT INTO SERVER_SETTINGS
VALUES ('DELETE_EMPTY_READLISTS', 'true');  -- Replace with actual default

-- PostgreSQL equivalent of SQLite's hex(randomblob(32))
INSERT INTO SERVER_SETTINGS
VALUES ('REMEMBER_ME_KEY', encode(gen_random_bytes(32), 'hex'));

INSERT INTO SERVER_SETTINGS
VALUES ('REMEMBER_ME_DURATION', '365');
