SELECT
    rss_item.id,
    rss_item.feed_id,
    rss_item.title,
    rss_item.link,
    rss_item.description,
    rss_item.enclosure_url
FROM
    rss_item
INNER JOIN
    rss_feed
    ON feed_id=rss_feed.id
WHERE
    rss_feed.user_id = $1
    AND feed_id = $2
