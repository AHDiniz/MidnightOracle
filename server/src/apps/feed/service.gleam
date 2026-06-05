import apps/feed/xml/feed as xml_feed
import apps/utils/errors.{type ServerResult}
import dao/rss_feed as feed_dao
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/result
import midnight_domain/rss_feed.{type RssFeed}

fn get_request(url: String) -> ServerResult(_) {
  use req <- result.try(request.to(url) |> errors.to_internal_error())
  let req = request.set_method(req, http.Get)

  httpc.send(req) |> errors.to_internal_error()
}

pub fn create_feed_from_url(
  rss_url: String,
  user_id: Int,
) -> ServerResult(Nil) {
  use res <- result.try(get_request(rss_url))

  use fields <- result.try(
    xml_feed.get_feed_fields(res.body) |> errors.to_bad_request(),
  )

  feed_dao.create_rss_feed(
    user_id,
    rss_url,
    fields.feed_url,
    fields.feed_title,
    fields.feed_description,
    fields.pub_date,
    fields.last_build,
    fields.image_url,
  )
  |> errors.to_internal_error()
}

pub fn get_feed(user_id: Int, feed_id: Int) -> ServerResult(String) {
  feed_dao.get_rss_feed_by_user_and_id(user_id, feed_id)
  |> errors.unwrap_result_option(fn() { Error(errors.InternalError) })
}

pub fn get_feeds_from_user(user_id: Int) -> ServerResult(List(RssFeed)) {
  feed_dao.list_rss_feed_by_user_id(user_id) |> errors.to_internal_error
}

pub fn update_feed_from_user(user_id: Int, feed_id: Int) -> ServerResult(_) {
  let get_res =
    feed_dao.get_rss_feed_by_user_and_id(user_id, feed_id)
    |> errors.unwrap_result_option(fn() { Error(errors.InternalError) })

  use rss_url <- result.try(get_res)
  use res <- result.try(get_request(rss_url))

  use fields <- result.try(
    xml_feed.get_feed_fields(res.body) |> errors.to_bad_request(),
  )

  feed_dao.update_rss_feed_by_id(
    feed_id,
    user_id,
    rss_url,
    fields.feed_url,
    fields.feed_title,
    fields.feed_description,
    fields.pub_date,
    fields.last_build,
    fields.image_url,
  )
  |> errors.to_internal_error()
}

pub fn delete_feed_from_user(user_id: Int, feed_id: Int) -> ServerResult(_) {
  feed_dao.delete_rss_feed_by_id(feed_id, user_id) |> errors.to_internal_error
}
