--- migration:up
CREATE TABLE feed_category(
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

  feed_id INT REFERENCES rss_feed ON DELETE CASCADE NOT NULL,
  category_id INT REFERENCES category ON DELETE CASCADE NOT NULL,

  UNIQUE(feed_id, category_id)
)

--- migration:down
DROP TABLE feed_category;

--- migration:end