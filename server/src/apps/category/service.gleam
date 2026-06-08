import apps/feed/utils
import apps/utils/errors.{type ServerResult}
import dao/category as category_dao
import midnight_domain/category.{type Category}

pub fn list_categories_by_user(user_id: Int) -> ServerResult(List(Category)) {
  category_dao.list_categories_by_user_id(user_id)
  |> errors.to_internal_error()
}

pub fn create_category(user_id: Int, name: String) -> ServerResult(Nil) {
  category_dao.create_category(user_id, name)
  |> errors.to_internal_error()
}

pub fn delete_category(user_id: Int, category_id: Int) -> ServerResult(Nil) {
  category_dao.delete_category_by_user_and_id(user_id, category_id)
  |> errors.to_internal_error()
}

pub fn list_categories_by_feed(
  user_id: Int,
  feed_id: Int,
) -> ServerResult(List(Category)) {
  // Checar se o usuário é dono do feed
  use <- utils.require_user_owns_feed(user_id, feed_id)

  category_dao.list_categories_by_feed_id(feed_id)
  |> errors.to_internal_error()
}

pub fn add_category_to_feed(
  user_id: Int,
  category_id: Int,
  feed_id: Int,
) -> ServerResult(Nil) {
  // Checar se o usuário é dono do feed
  use <- utils.require_user_owns_feed(user_id, feed_id)

  category_dao.add_category_to_feed(category_id, feed_id)
  |> errors.to_internal_error()
}

pub fn remove_category_from_feed(
  user_id: Int,
  category_id: Int,
  feed_id: Int,
) -> ServerResult(Nil) {
  // Checar se o usuário é dono do feed
  use <- utils.require_user_owns_feed(user_id, feed_id)

  category_dao.remove_category_from_feed(category_id, feed_id)
  |> errors.to_internal_error()
}

pub fn list_categories_by_item(
  user_id: Int,
  item_id: Int,
) -> ServerResult(List(Category)) {
  // Checar se o usuário é dono do item
  use <- utils.require_user_owns_item(user_id, item_id)

  category_dao.list_categories_by_item_id(item_id)
  |> errors.to_internal_error()
}

pub fn add_category_to_item(
  user_id: Int,
  category_id: Int,
  item_id: Int,
) -> ServerResult(Nil) {
  // Checar se o usuário é dono do item
  use <- utils.require_user_owns_item(user_id, item_id)

  category_dao.add_category_to_item(category_id, item_id)
  |> errors.to_internal_error()
}

pub fn remove_category_from_item(
  user_id: Int,
  category_id: Int,
  item_id: Int,
) -> ServerResult(Nil) {
  // Checar se o usuário é dono do item
  use <- utils.require_user_owns_item(user_id, item_id)

  category_dao.remove_category_from_item(category_id, item_id)
  |> errors.to_internal_error()
}
