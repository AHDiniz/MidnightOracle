import dao/base.{type DAOResult} as base_dao
import dao/rss_item/sql
import midnight_domain/rss_item

pub fn list_rss_items_by_user_and_feed(
  user_id: Int,
  feed_id: Int,
) -> DAOResult(_) {
  base_dao.run_list_query(
    fn(conn) { sql.list_items_by_feed_and_user(conn, user_id, feed_id) },
    fn(row) {
      rss_item.RssItem(
        row.id,
        row.feed_id,
        row.title,
        row.link,
        row.description,
        row.enclosure_url,
      )
    },
  )
}

pub fn create_rss_item(
  feed_id: Int,
  title: String,
  link: String,
  description: String,
  enclosure_url: String,
) -> DAOResult(Nil) {
  base_dao.run_nil_query(fn(conn) {
    sql.create_item(conn, feed_id, title, link, description, enclosure_url)
  })
}
