import dao/base.{type DAOResult} as base_dao
import dao/category/sql
import midnight_domain/category.{type Category}

pub fn list_categories_by_user_id(user_id: Int) -> DAOResult(List(Category)) {
  base_dao.run_list_query(
    fn(conn) { sql.list_category_by_user(conn, user_id) },
    fn(row) { category.Category(row.id, row.name) },
  )
}

pub fn create_category(user_id: Int, name: String) -> DAOResult(Nil) {
  base_dao.run_nil_query(fn(conn) { sql.create_category(conn, user_id, name) })
}
