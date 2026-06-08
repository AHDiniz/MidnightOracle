import gleam/dynamic/decode
import gleam/json

pub type RssItem {
  RssItem(
    id: Int,
    feed_id: Int,
    title: String,
    link: String,
    description: String,
    enclosure_url: String,
  )
}

pub fn decoder() -> decode.Decoder(RssItem) {
  use id <- decode.field("id", decode.int)
  use feed_id <- decode.field("feed_id", decode.int)
  use title <- decode.field("title", decode.string)
  use link <- decode.field("link", decode.string)
  use description <- decode.field("description", decode.string)
  use enclosure_url <- decode.field("enclosure_url", decode.string)
  decode.success(RssItem(
    id:,
    feed_id:,
    title:,
    link:,
    description:,
    enclosure_url:,
  ))
}

pub fn to_json(rss_item: RssItem) -> json.Json {
  let RssItem(id:, feed_id:, title:, link:, description:, enclosure_url:) =
    rss_item
  json.object([
    #("id", json.int(id)),
    #("feed_id", json.int(feed_id)),
    #("title", json.string(title)),
    #("link", json.string(link)),
    #("description", json.string(description)),
    #("enclosure_url", json.string(enclosure_url)),
  ])
}
