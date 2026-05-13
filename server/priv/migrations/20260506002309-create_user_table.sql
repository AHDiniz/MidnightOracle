--- migration:up
CREATE TABLE users(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    password BYTEA NOT NULL
);

--- migration:down
DROP TABLE users;

--- migration:end
