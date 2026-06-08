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

pub fn delete_category_by_user_and_id(
  user_id: Int,
  category_id: Int,
) -> DAOResult(Nil) {
  base_dao.run_nil_query(fn(conn) {
    sql.delete_category_by_user_and_id(conn, user_id, category_id)
  })
}

pub fn list_categories_by_feed_id(feed_id: Int) -> DAOResult(List(Category)) {
  base_dao.run_list_query(
    fn(conn) { sql.list_category_by_feed(conn, feed_id) },
    fn(row) { category.Category(row.id, row.name) },
  )
}

pub fn add_category_to_feed(category_id: Int, feed_id: Int) -> DAOResult(Nil) {
  base_dao.run_nil_query(fn(conn) {
    sql.add_category_to_feed(conn, category_id, feed_id)
  })
}

pub fn remove_category_from_feed(
  category_id: Int,
  feed_id: Int,
) -> DAOResult(Nil) {
  base_dao.run_nil_query(fn(conn) {
    sql.remove_category_from_feed(conn, category_id, feed_id)
  })
}
