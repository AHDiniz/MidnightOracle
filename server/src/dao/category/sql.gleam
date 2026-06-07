//// This module contains the code to run the sql queries defined in
//// `./src/dao/category/sql`.
//// > 🐿️ This module was generated automatically using v4.7.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// Runs the `add_category_to_feed` query
/// defined in `./src/dao/category/sql/add_category_to_feed.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn add_category_to_feed(
  db: pog.Connection,
  arg_1: Int,
  arg_2: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "INSERT INTO feed_category(
  category_id,
  feed_id
)
VALUES ($1, $2)
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `add_category_to_item` query
/// defined in `./src/dao/category/sql/add_category_to_item.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn add_category_to_item(
  db: pog.Connection,
  arg_1: Int,
  arg_2: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "INSERT INTO item_category(
  category_id,
  item_id
)
VALUES ($1, $2)
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `create_category` query
/// defined in `./src/dao/category/sql/create_category.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_category(
  db: pog.Connection,
  arg_1: Int,
  arg_2: String,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "INSERT INTO category(
  user_id,
  name
)
VALUES ($1, $2)
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `delete_category_by_user_and_id` query
/// defined in `./src/dao/category/sql/delete_category_by_user_and_id.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn delete_category_by_user_and_id(
  db: pog.Connection,
  user_id: Int,
  id: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "DELETE FROM category
WHERE user_id = $1 AND id = $2
"
  |> pog.query
  |> pog.parameter(pog.int(user_id))
  |> pog.parameter(pog.int(id))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `list_category_by_feed` query
/// defined in `./src/dao/category/sql/list_category_by_feed.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListCategoryByFeedRow {
  ListCategoryByFeedRow(id: Int, name: String)
}

/// Runs the `list_category_by_feed` query
/// defined in `./src/dao/category/sql/list_category_by_feed.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_category_by_feed(
  db: pog.Connection,
  feed_category_feed_id: Int,
) -> Result(pog.Returned(ListCategoryByFeedRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    decode.success(ListCategoryByFeedRow(id:, name:))
  }

  "SELECT
  category.id, category.name
FROM
  category
INNER JOIN
  feed_category
  ON feed_category.category_id = category.id
WHERE
  feed_category.feed_id = $1
"
  |> pog.query
  |> pog.parameter(pog.int(feed_category_feed_id))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `list_category_by_item` query
/// defined in `./src/dao/category/sql/list_category_by_item.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListCategoryByItemRow {
  ListCategoryByItemRow(id: Int, name: String)
}

/// Runs the `list_category_by_item` query
/// defined in `./src/dao/category/sql/list_category_by_item.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_category_by_item(
  db: pog.Connection,
  item_category_item_id: Int,
) -> Result(pog.Returned(ListCategoryByItemRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    decode.success(ListCategoryByItemRow(id:, name:))
  }

  "SELECT
  category.id, category.name
FROM
  category
INNER JOIN
  item_category
  ON item_category.category_id = category.id
WHERE
  item_category.item_id = $1
"
  |> pog.query
  |> pog.parameter(pog.int(item_category_item_id))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `list_category_by_user` query
/// defined in `./src/dao/category/sql/list_category_by_user.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.7.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListCategoryByUserRow {
  ListCategoryByUserRow(id: Int, name: String)
}

/// Runs the `list_category_by_user` query
/// defined in `./src/dao/category/sql/list_category_by_user.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_category_by_user(
  db: pog.Connection,
  user_id: Int,
) -> Result(pog.Returned(ListCategoryByUserRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    decode.success(ListCategoryByUserRow(id:, name:))
  }

  "SELECT
  id, name
FROM
  category
WHERE
  user_id = $1
"
  |> pog.query
  |> pog.parameter(pog.int(user_id))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `remove_category_from_feed` query
/// defined in `./src/dao/category/sql/remove_category_from_feed.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn remove_category_from_feed(
  db: pog.Connection,
  category_id: Int,
  feed_id: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "DELETE FROM feed_category
WHERE category_id = $1 AND feed_id = $2
"
  |> pog.query
  |> pog.parameter(pog.int(category_id))
  |> pog.parameter(pog.int(feed_id))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `remove_category_from_item` query
/// defined in `./src/dao/category/sql/remove_category_from_item.sql`.
///
/// > 🐿️ This function was generated automatically using v4.7.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn remove_category_from_item(
  db: pog.Connection,
  category_id: Int,
  item_id: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "DELETE FROM item_category
WHERE category_id = $1 AND item_id = $2
"
  |> pog.query
  |> pog.parameter(pog.int(category_id))
  |> pog.parameter(pog.int(item_id))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
