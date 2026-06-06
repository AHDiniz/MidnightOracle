import apps/utils/errors.{type ServerResult}
import dao/rss_item as item_dao
import midnight_domain/rss_item.{type RssItem}

/// Recebe o ID do usuário, para garantir que o feed pertence ao usuário
pub fn list_feed_saved_items(
  user_id: Int,
  feed_id: Int,
) -> ServerResult(List(RssItem)) {
  item_dao.list_rss_items_by_user_and_feed(user_id, feed_id)
  |> errors.to_internal_error()
}
