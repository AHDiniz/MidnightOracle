//// Basic/Generic definitions for the DAOs

import gleam/option.{type Option}
import gleam/result
import pog

/// Errors that can happen on any operation
pub type DAOError {
  PogError(pog.QueryError)
  MultipleGetError
  // EmptyGetError
}

pub fn handle_get_result(
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
