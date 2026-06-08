SELECT EXISTS (
  SELECT 1
  FROM rss_item
  INNER JOIN rss_feed
    ON rss_item.feed_id = rss_feed.id
  WHERE rss_feed.user_id = $1 AND rss_item.id = $2
)
