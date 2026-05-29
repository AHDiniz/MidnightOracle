import apps/feed/xml
import apps/utils/errors
import dao/rss_feed
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/result

pub fn create_feed_from_url(feed_url: String, user_id: Int) -> Result(_, _) {
  let req =
    request.to(feed_url)
    |> errors.to_internal_error()
  use req <- result.try(req)
  let req = request.set_method(req, http.Get)

  use res <- result.try(httpc.send(req) |> errors.to_internal_error())

  use fields <- result.try(
    xml.get_feed_fields(res.body) |> errors.to_bad_request(),
  )

  rss_feed.create_rss_feed(
    user_id,
    fields.feed_url,
    fields.feed_title,
    fields.feed_description,
    fields.pub_date,
    fields.last_build,
    fields.image_url,
  )
  |> errors.to_internal_error()
}
