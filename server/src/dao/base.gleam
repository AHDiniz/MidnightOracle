//// Basic/Generic definitions for the DAOs

import dao/utils
import gleam/option.{type Option}
import gleam/result
import pog

/// Errors that can happen on any operation
pub type DAOError {
  PogError(pog.QueryError)
  MultipleGetError
  // EmptyGetError
}

fn handle_get_result(
  result: Result(pog.Returned(row_type), pog.QueryError),
  constructor: fn(row_type) -> domain_type,
) -> Result(Option(domain_type), DAOError) {
  case result.map(result, fn(x) { x.rows }) {
    Ok([]) -> Ok(option.None)
    Ok([row]) -> Ok(option.Some(constructor(row)))
    Ok(_) -> Error(MultipleGetError)
    Error(x) -> Error(PogError(x))
  }
}

pub fn generic_get(
  query_fn: fn(pog.Connection) -> Result(pog.Returned(row_type), pog.QueryError),
  constructor: fn(row_type) -> domain_type,
) -> Result(Option(domain_type), DAOError) {
  utils.get_pog_connection() |> query_fn() |> handle_get_result(constructor)
}

fn handle_create_result(
  result: Result(pog.Returned(Nil), pog.QueryError),
) -> Result(Nil, DAOError) {
  case result {
    Ok(_) -> Ok(Nil)
    Error(x) -> Error(PogError(x))
  }
}

pub fn generic_create(
  query_fn: fn(pog.Connection) -> Result(pog.Returned(_), pog.QueryError),
) -> Result(Nil, DAOError) {
  utils.get_pog_connection() |> query_fn() |> handle_create_result()
}
