import gleam/time/timestamp.{type Timestamp}

pub type RssFeed {
  RssFeed(
    id: Int,
    user_id: Int,
    feed_url: String,
    feed_title: String,
    feed_description: String,
    pub_date: Timestamp,
    last_build: Timestamp,
    image_url: String,
  )
}
