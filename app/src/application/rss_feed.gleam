import application/utils
import gleam/dynamic/decode
import gleam/http
import gleam/http/request
import gleam/json
import lustre/effect
import messages as msg
import midnight_domain/rss_feed
import rsvp

type Ret =
  effect.Effect(msg.Message)

pub fn create_rss_feed(token: String, feed_url: String) -> Ret {
  let body =
    [#("feed_url", json.string(feed_url))]
    |> json.object()
    |> json.to_string()

  let request =
    utils.build_authorized_request(token)
    |> request.set_method(http.Post)
    |> request.set_path("feed")
    |> request.set_body(body)

  let handler = rsvp.expect_ok_response(msg.CreateFeedRequest)

  rsvp.send(request, handler)
}

pub fn list_rss_feed(token: String) -> Ret {
  let request =
    utils.build_authorized_request(token)
    |> request.set_method(http.Get)
    |> request.set_path("feed")

  let decoder = decode.list(rss_feed.decoder())
  let handler = rsvp.expect_json(decoder, msg.ListFeedRequest)

  rsvp.send(request, handler)
}
