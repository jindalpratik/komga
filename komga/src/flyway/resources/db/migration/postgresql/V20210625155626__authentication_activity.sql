CREATE TABLE AUTHENTICATION_ACTIVITY
(
    USER_ID    text      NULL     DEFAULT NULL,
    EMAIL      text      NULL     DEFAULT NULL,
    IP         text      NULL     DEFAULT NULL,
    USER_AGENT text      NULL     DEFAULT NULL,
    SUCCESS    boolean   NOT NULL,
    ERROR      text      NULL     DEFAULT NULL,
    DATE_TIME  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (USER_ID) REFERENCES "user" (ID)
);

-- Add indexes for performance
CREATE INDEX idx_authentication_activity_user_id ON AUTHENTICATION_ACTIVITY(USER_ID);
CREATE INDEX idx_authentication_activity_email ON AUTHENTICATION_ACTIVITY(EMAIL);
CREATE INDEX idx_authentication_activity_date_time ON AUTHENTICATION_ACTIVITY(DATE_TIME);
CREATE INDEX idx_authentication_activity_success ON AUTHENTICATION_ACTIVITY(SUCCESS);
