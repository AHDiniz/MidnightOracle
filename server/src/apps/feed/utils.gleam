import apps/feed/xml/feed as xml_feed
import apps/utils/errors.{type ServerResult}
import dao/rss_feed as feed_dao
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/result

pub fn get_request(url: String) -> ServerResult(_) {
  use req <- result.try(request.to(url) |> errors.to_internal_error())
  let req = request.set_method(req, http.Get)

  httpc.send(req) |> errors.to_internal_error()
}

pub fn get_rss_fields_from_url(
  rss_url: String,
) -> ServerResult(xml_feed.RssFeedFields) {
  use res <- result.try(get_request(rss_url))

  xml_feed.get_feed_fields(res.body) |> errors.to_bad_request()
}

pub fn require_user_owns_feed(
  user_id: Int,
  feed_id: Int,
  next: fn() -> ServerResult(a),
) -> ServerResult(a) {
  case feed_dao.check_user_owns_feed(user_id, feed_id) {
    Ok(True) -> next()
    _ -> Error(Nil) |> errors.to_internal_error()
  }
}
