--- migration:up
CREATE TABLE item_category(
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

  item_id INT REFERENCES rss_item ON DELETE CASCADE NOT NULL,
  category_id INT REFERENCES category ON DELETE CASCADE NOT NULL,

  UNIQUE(item_id, category_id)
)

--- migration:down
DROP TABLE item_category;

--- migration:end