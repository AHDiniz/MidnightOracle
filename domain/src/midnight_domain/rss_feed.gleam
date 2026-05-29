pub type RssFeed {
  RssFeed(
    id: Int,
    user_id: Int,
    feed_url: String,
    feed_title: String,
    feed_description: String,
    pub_date: String,
    last_build: String,
    image_url: String,
  )
}
