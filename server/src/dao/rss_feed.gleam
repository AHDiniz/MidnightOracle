import dao/base.{type DAOResult} as base_dao
import dao/rss_feed/sql

pub fn create_rss_feed(
  user_id: Int,
  feed_url: String,
  feed_title: String,
  feed_description: String,
  pub_date: String,
  last_build: String,
  image_url: String,
) -> DAOResult(Nil) {
  base_dao.generic_create(fn(conn) {
    sql.create_feed(
      conn,
      user_id,
      feed_url,
      feed_title,
      feed_description,
      pub_date,
      last_build,
      image_url,
    )
  })
}
