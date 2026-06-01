SELECT rss_url
FROM rss_feed
WHERE user_id=$1 AND id=$2
