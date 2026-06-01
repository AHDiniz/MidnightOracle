--- migration:up
CREATE TABLE rss_feed(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id INT REFERENCES users NOT NULL,
    rss_url TEXT NOT NULL,
    feed_url TEXT NOT NULL,
    feed_title TEXT NOT NULL,
    feed_description TEXT NOT NULL,
    pub_date TEXT NOT NULL,
    last_build TEXT NOT NULL,
    image_url TEXT NOT NULL,

    UNIQUE(user_id, feed_url)
)

--- migration:down
DROP TABLE rss_feed;

--- migration:end