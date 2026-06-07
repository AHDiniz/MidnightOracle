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
