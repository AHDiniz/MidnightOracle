--- migration:up
CREATE TABLE rss_item(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    feed_id INT REFERENCES rss_feed ON DELETE CASCADE NOT NULL,

    title TEXT NOT NULL,
    link TEXT NOT NULL,
    description TEXT NOT NULL,
    enclosure_url TEXT NOT NULL
)

--- migration:down
DROP TABLE rss_item;

--- migration:end