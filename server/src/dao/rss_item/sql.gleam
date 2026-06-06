//// This module contains the code to run the sql queries defined in
//// `./src/dao/rss_item/sql`.
//// > 🐿️ This module was generated automatically using v4.7.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// Runs the `create_item` query
/// defined in `./src/dao/rss_item/sql/create_item.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_item(
  db: pog.Connection,
  arg_1: Int,
  arg_2: String,
  arg_3: String,
  arg_4: String,
  arg_5: String,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "INSERT INTO rss_item(
  feed_id,
  title,
  link,
  description,
  enclosure_url
)
VALUES ($1, $2, $3, $4, $5)
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.parameter(pog.text(arg_5))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `list_items_by_feed_and_user` query
/// defined in `./src/dao/rss_item/sql/list_items_by_feed_and_user.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListItemsByFeedAndUserRow {
  ListItemsByFeedAndUserRow(
    id: Int,
    feed_id: Int,
    title: String,
    link: String,
    description: String,
    enclosure_url: String,
  )
}

/// Runs the `list_items_by_feed_and_user` query
/// defined in `./src/dao/rss_item/sql/list_items_by_feed_and_user.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_items_by_feed_and_user(
  db: pog.Connection,
  rss_feed_user_id: Int,
  feed_id: Int,
) -> Result(pog.Returned(ListItemsByFeedAndUserRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use feed_id <- decode.field(1, decode.int)
    use title <- decode.field(2, decode.string)
    use link <- decode.field(3, decode.string)
    use description <- decode.field(4, decode.string)
    use enclosure_url <- decode.field(5, decode.string)
    decode.success(ListItemsByFeedAndUserRow(
      id:,
      feed_id:,
      title:,
      link:,
      description:,
      enclosure_url:,
    ))
  }

  "SELECT
    rss_item.id,
    rss_item.feed_id,
    rss_item.title,
    rss_item.link,
    rss_item.description,
    rss_item.enclosure_url
FROM
    rss_item
INNER JOIN
    rss_feed
    ON feed_id=rss_feed.id
WHERE
    rss_feed.user_id = $1
    AND feed_id = $2
"
  |> pog.query
  |> pog.parameter(pog.int(rss_feed_user_id))
  |> pog.parameter(pog.int(feed_id))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
