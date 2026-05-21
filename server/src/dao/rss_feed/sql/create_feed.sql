INSERT INTO rss_feed(
  user_id,
  feed_url,
  feed_title,
  feed_description,
  pub_date,
  last_build,
  image_url
)
VALUES ($1, $2, $3, $4, $5, $6, $7)
