SELECT
  id,
  user_id,
  rss_url,
  feed_url,
  feed_title,
  feed_description,
  pub_date,
  last_build,
  image_url
FROM rss_feed
WHERE user_id = $1
