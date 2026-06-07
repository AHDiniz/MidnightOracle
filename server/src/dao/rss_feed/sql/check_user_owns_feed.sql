SELECT EXISTS (
  SELECT 1
  FROM rss_feed
  WHERE user_id = $1 AND rss_feed.id = $2
)
