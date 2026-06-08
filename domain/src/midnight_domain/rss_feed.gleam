import gleam/dynamic/decode
import gleam/json

pub type RssFeed {
  RssFeed(
    id: Int,
    user_id: Int,
    rss_url: String,
    feed_url: String,
    feed_title: String,
    feed_description: String,
    pub_date: String,
    last_build: String,
    image_url: String,
  )
}

pub fn decoder() -> decode.Decoder(RssFeed) {
  use id <- decode.field("id", decode.int)
  use user_id <- decode.field("user_id", decode.int)
  use rss_url <- decode.field("rss_url", decode.string)
  use feed_url <- decode.field("feed_url", decode.string)
  use feed_title <- decode.field("feed_title", decode.string)
  use feed_description <- decode.field("feed_description", decode.string)
  use pub_date <- decode.field("pub_date", decode.string)
  use last_build <- decode.field("last_build", decode.string)
  use image_url <- decode.field("image_url", decode.string)
  decode.success(RssFeed(
    id:,
    user_id:,
    rss_url:,
    feed_url:,
    feed_title:,
    feed_description:,
    pub_date:,
    last_build:,
    image_url:,
  ))
}

pub fn to_json(rss_feed: RssFeed) -> json.Json {
  let RssFeed(
    id:,
    user_id:,
    rss_url:,
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
    #("rss_url", json.string(rss_url)),
    #("feed_url", json.string(feed_url)),
    #("feed_title", json.string(feed_title)),
    #("feed_description", json.string(feed_description)),
    #("pub_date", json.string(pub_date)),
    #("last_build", json.string(last_build)),
    #("image_url", json.string(image_url)),
  ])
}
