import gleam/json

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

pub fn encoder(rss_feed: RssFeed) -> json.Json {
  let RssFeed(
    id:,
    user_id:,
    feed_url:,
    feed_title:,
    feed_description:,
    pub_date:,
    last_build:,
    image_url:,
  ) = rss_feed
  json.object([
    #("id", json.int(id)),
    #("user_id", json.int(user_id)),
    #("feed_url", json.string(feed_url)),
    #("feed_title", json.string(feed_title)),
    #("feed_description", json.string(feed_description)),
    #("pub_date", json.string(pub_date)),
    #("last_build", json.string(last_build)),
    #("image_url", json.string(image_url)),
  ])
}
