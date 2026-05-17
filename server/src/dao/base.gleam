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

pub type DAOResult(a) =
  Result(a, DAOError)

fn handle_get_result(
  result: Result(pog.Returned(row_type), pog.QueryError),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(Option(domain_type)) {
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
) -> DAOResult(Option(domain_type)) {
  utils.get_pog_connection() |> query_fn() |> handle_get_result(constructor)
}

fn handle_create_result(
  result: Result(pog.Returned(Nil), pog.QueryError),
) -> DAOResult(Nil) {
  case result {
    Ok(_) -> Ok(Nil)
    Error(x) -> Error(PogError(x))
  }
}

pub fn generic_create(
  query_fn: fn(pog.Connection) -> Result(pog.Returned(_), pog.QueryError),
) -> DAOResult(Nil) {
  utils.get_pog_connection() |> query_fn() |> handle_create_result()
}
