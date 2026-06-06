INSERT INTO rss_item(
  feed_id,
  title,
  link,
  description,
  enclosure_url
)
VALUES ($1, $2, $3, $4, $5)
