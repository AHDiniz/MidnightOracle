import apps/feed/utils
import apps/utils/errors.{type ServerResult}
import dao/rss_feed as feed_dao
import gleam/result
import midnight_domain/rss_feed.{type RssFeed}

pub fn create_feed_from_url(
  rss_url: String,
  user_id: Int,
) -> ServerResult(Nil) {
  use fields <- result.try(utils.get_rss_fields_from_url(rss_url))

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

pub fn get_feed_url(user_id: Int, feed_id: Int) -> ServerResult(String) {
  feed_dao.get_rss_feed_by_user_and_id(user_id, feed_id)
  |> errors.unwrap_result_option(fn() { Error(errors.InternalError) })
}

pub fn get_feeds_from_user(user_id: Int) -> ServerResult(List(RssFeed)) {
  feed_dao.list_rss_feed_by_user_id(user_id) |> errors.to_internal_error
}

pub fn update_feed_from_user(user_id: Int, feed_id: Int) -> ServerResult(_) {
  use rss_url <- result.try(get_feed_url(user_id, feed_id))
  use fields <- result.try(utils.get_rss_fields_from_url(rss_url))

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
