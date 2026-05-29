//// This module contains the code to run the sql queries defined in
//// `./src/dao/rss_feed/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// Runs the `create_feed` query
/// defined in `./src/dao/rss_feed/sql/create_feed.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_feed(
  db: pog.Connection,
  arg_1: Int,
  arg_2: String,
  arg_3: String,
  arg_4: String,
  arg_5: String,
  arg_6: String,
  arg_7: String,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "INSERT INTO rss_feed(
  user_id,
  feed_url,
  feed_title,
  feed_description,
  pub_date,
  last_build,
  image_url
)
VALUES ($1, $2, $3, $4, $5, $6, $7)
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.parameter(pog.text(arg_5))
  |> pog.parameter(pog.text(arg_6))
  |> pog.parameter(pog.text(arg_7))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `list_feeds_by_user_id` query
/// defined in `./src/dao/rss_feed/sql/list_feeds_by_user_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListFeedsByUserIdRow {
  ListFeedsByUserIdRow(
    id: Int,
    user_id: Int,
    feed_url: String,
    feed_title: String,
    feed_description: String,
    pub_date: String,
    last_build: String,
    image_url: String,
  )
}

/// Runs the `list_feeds_by_user_id` query
/// defined in `./src/dao/rss_feed/sql/list_feeds_by_user_id.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_feeds_by_user_id(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(ListFeedsByUserIdRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use user_id <- decode.field(1, decode.int)
    use feed_url <- decode.field(2, decode.string)
    use feed_title <- decode.field(3, decode.string)
    use feed_description <- decode.field(4, decode.string)
    use pub_date <- decode.field(5, decode.string)
    use last_build <- decode.field(6, decode.string)
    use image_url <- decode.field(7, decode.string)
    decode.success(ListFeedsByUserIdRow(
      id:,
      user_id:,
      feed_url:,
      feed_title:,
      feed_description:,
      pub_date:,
      last_build:,
      image_url:,
    ))
  }

  "SELECT
  id,
  user_id,
  feed_url,
  feed_title,
  feed_description,
  pub_date,
  last_build,
  image_url
FROM rss_feed
WHERE user_id = $1
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
