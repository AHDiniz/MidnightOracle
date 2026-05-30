import dao/base.{type DAOResult} as base_dao
import dao/rss_feed/sql
import midnight_domain/rss_feed.{type RssFeed}

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

pub fn list_rss_feed_by_user_id(user_id: Int) -> DAOResult(List(RssFeed)) {
  base_dao.generic_list(
    fn(conn) { sql.list_feeds_by_user_id(conn, user_id) },
    fn(row) {
      rss_feed.RssFeed(
        row.id,
        row.user_id,
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
