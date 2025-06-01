CREATE TABLE CLIENT_SETTINGS_GLOBAL
(
    KEY                text    NOT NULL PRIMARY KEY,
    VALUE              text    NOT NULL,
    ALLOW_UNAUTHORIZED boolean NOT NULL DEFAULT FALSE
);

CREATE TABLE CLIENT_SETTINGS_USER
(
    USER_ID text NOT NULL,
    KEY     text NOT NULL,
    VALUE   text NOT NULL,
    FOREIGN KEY (USER_ID) REFERENCES "user" (ID),
    PRIMARY KEY (KEY, USER_ID)
);

-- Add index for performance
CREATE INDEX idx__client_settings_user__user_id ON CLIENT_SETTINGS_USER (USER_ID);
