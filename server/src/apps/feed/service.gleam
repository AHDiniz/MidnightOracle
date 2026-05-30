import apps/feed/xml
import apps/utils/errors.{type ServerResult}
import dao/rss_feed as feed_dao
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/result
import midnight_domain/rss_feed.{type RssFeed}

pub fn create_feed_from_url(
  feed_url: String,
  user_id: Int,
) -> ServerResult(Nil) {
  use req <- result.try(request.to(feed_url) |> errors.to_internal_error())
  let req = request.set_method(req, http.Get)

  use res <- result.try(httpc.send(req) |> errors.to_internal_error())

  use fields <- result.try(
    xml.get_feed_fields(res.body) |> errors.to_bad_request(),
  )

  feed_dao.create_rss_feed(
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

pub fn get_feeds_from_user(user_id: Int) -> ServerResult(List(RssFeed)) {
  feed_dao.list_rss_feed_by_user_id(user_id) |> errors.to_internal_error
}
