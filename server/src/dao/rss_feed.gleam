import dao/base.{type DAOResult} as base_dao
import dao/rss_feed/sql
import gleam/option.{type Option}
import midnight_domain/rss_feed.{type RssFeed}

pub fn create_rss_feed(
  user_id: Int,
  rss_url: String,
  feed_url: String,
  feed_title: String,
  feed_description: String,
  pub_date: String,
  last_build: String,
  image_url: String,
) -> DAOResult(Nil) {
  base_dao.run_nil_query(fn(conn) {
    sql.create_feed(
      conn,
      user_id,
      rss_url,
      feed_url,
      feed_title,
      feed_description,
      pub_date,
      last_build,
      image_url,
    )
  })
}

pub fn list_rss_feed_by_user_id(user_id: Int) -> DAOResult(List(RssFeed)) {
  base_dao.run_list_query(
    fn(conn) { sql.list_feeds_by_user_id(conn, user_id) },
    fn(row) {
      rss_feed.RssFeed(
        row.id,
        row.user_id,
        row.rss_url,
        row.feed_url,
        row.feed_title,
        row.feed_description,
        row.pub_date,
        row.last_build,
        row.image_url,
      )
    },
  )
}

pub fn get_rss_feed_by_user_and_id(
  user_id: Int,
  id: Int,
) -> DAOResult(Option(String)) {
  base_dao.run_get_query(
    fn(conn) { sql.get_feed_by_user_and_id(conn, user_id, id) },
    fn(row) { row.rss_url },
  )
}

pub fn update_rss_feed_by_id(
  rss_feed_id: Int,
  user_id: Int,
  rss_url: String,
  feed_url: String,
  feed_title: String,
  feed_description: String,
  pub_date: String,
  last_build: String,
  image_url: String,
) -> DAOResult(Nil) {
  base_dao.run_nil_query(fn(conn) {
    sql.update_feed_by_id(
      conn,
      rss_feed_id,
      user_id,
      rss_url,
      feed_url,
      feed_title,
      feed_description,
      pub_date,
      last_build,
      image_url,
    )
  })
}

pub fn delete_rss_feed_by_id(rss_feed_id: Int, user_id: Int) -> DAOResult(Nil) {
  base_dao.run_nil_query(fn(conn) {
    sql.delete_feed_by_user_and_id(conn, rss_feed_id, user_id)
  })
}

pub fn check_user_owns_feed(user_id: Int, feed_id: Int) -> DAOResult(Bool) {
  base_dao.run_check_query(
    fn(conn) { sql.check_user_owns_feed(conn, user_id, feed_id) },
    fn(x) { x.exists },
  )
}
