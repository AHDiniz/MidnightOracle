UPDATE rss_feed
SET (
  user_id,
  rss_url,
  feed_url,
  feed_title,
  feed_description,
  pub_date,
  last_build,
  image_url
) = ($2, $3, $4, $5, $6, $7, $8, $9)
WHERE id = $1
