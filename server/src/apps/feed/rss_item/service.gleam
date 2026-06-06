import apps/feed/service as feed_service
import apps/feed/utils
import apps/feed/xml/item as xml
import apps/utils/errors.{type ServerResult}
import dao/rss_item as item_dao
import gleam/result
import midnight_domain/rss_item.{type RssItem}

pub fn read_feed_items_from_url(rss_url: String) -> ServerResult(List(_)) {
  use rss_response <- result.try(utils.get_request(rss_url))

  xml.get_feed_items(rss_response.body) |> errors.to_bad_request()
}

/// Recebe o ID do usuário, para garantir que o feed pertence ao usuário
pub fn list_feed_saved_items(
  user_id: Int,
  feed_id: Int,
) -> ServerResult(List(RssItem)) {
  item_dao.list_rss_items_by_user_and_feed(user_id, feed_id)
  |> errors.to_internal_error()
}

pub fn save_feed_item(
  user_id: Int,
  feed_id: Int,
  title: String,
  link: String,
  description: String,
  enclosure_url: String,
) -> ServerResult(Nil) {
  // Checar se o usuário é dono do feed
  use _ <- result.try(feed_service.get_feed_url(user_id, feed_id))

  item_dao.create_rss_item(feed_id, title, link, description, enclosure_url)
  |> errors.to_internal_error()
}
