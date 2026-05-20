--- migration:up
CREATE TABLE rss_feed(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id INT REFERENCES users NOT NULL,
    feed_url TEXT NOT NULL,
    feed_title TEXT NOT NULL,
    feed_description TEXT NOT NULL,
    pub_date TIMESTAMP NOT NULL,
    last_build TIMESTAMP NOT NULL,
)

--- migration:down
DROP TABLE rss_feed;

--- migration:end