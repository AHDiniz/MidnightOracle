--- migration:up
CREATE TABLE auth_token(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id INT REFERENCES users NOT NULL UNIQUE,
    token BYTEA NOT NULL UNIQUE,
    expires_at TIMESTAMP DEFAULT NOW() + '1 hour'
);

--- migration:down
DROP TABLE auth_token;

--- migration:end