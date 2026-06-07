--- migration:up
CREATE TABLE category(
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

  user_id INT REFERENCES users NOT NULL,

  name TEXT NOT NULL CHECK (name != ''),

  UNIQUE(user_id, name)
)

--- migration:down
DROP TABLE category;

--- migration:end