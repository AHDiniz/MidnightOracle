import application/utils
import gleam/dynamic/decode
import gleam/http
import gleam/http/request
import gleam/int
import gleam/json
import lustre/effect
import messages as msg
import midnight_domain/rss_item
import rsvp

type Ret =
  effect.Effect(msg.Message)

pub fn list_items_from_feed(token: String, feed_id: Int) -> Ret {
  let request =
    utils.build_authorized_request(token)
    |> request.set_path(feed_item_path(feed_id))
    |> request.set_method(http.Get)

  let decoder =
    {
      use title <- decode.field("title", decode.string)
      use link <- decode.field("link", decode.string)
      use description <- decode.field("description", decode.string)
      use enclosure_url <- decode.field("enclosure_url", decode.string)

      decode.success(#(title, link, description, enclosure_url))
    }
    |> decode.list()

  let handler = rsvp.expect_json(decoder, msg.ListLiveItemRequest)

  rsvp.send(request, handler)
}

pub fn save_item_from_feed(token: String, item: rss_item.RssItem) -> Ret {
  let body =
    [
      #("title", json.string(item.title)),
      #("link", json.string(item.link)),
      #("description", json.string(item.description)),
      #("enclosure_url", json.string(item.enclosure_url)),
    ]
    |> json.object()
    |> json.to_string()

  let request =
    utils.build_authorized_request(token)
    |> request.set_path(feed_item_path(item.feed_id))
    |> request.set_method(http.Post)
    |> request.set_body(body)

  let handler = rsvp.expect_ok_response(msg.SaveItemRequest)

  rsvp.send(request, handler)
}

pub fn list_saved_item_from_feed(token: String, feed_id: Int) -> Ret {
  let request =
    utils.build_authorized_request(token)
    |> request.set_path(feed_item_path(feed_id) <> "/saved")
    |> request.set_method(http.Get)

  let decoder = decode.list(rss_item.decoder())

  let handler = rsvp.expect_json(decoder, msg.ListSavedItemRequest)

  rsvp.send(request, handler)
}

fn feed_item_path(feed_id: Int) -> String {
  "feed/" <> int.to_string(feed_id) <> "/item"
}
