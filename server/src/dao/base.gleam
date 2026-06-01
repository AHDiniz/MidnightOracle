//// Basic/Generic definitions for the DAOs

import dao/utils
import gleam/list
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

type PogResult(a) =
  Result(pog.Returned(a), pog.QueryError)

type QueryFn(a) =
  fn(pog.Connection) -> PogResult(a)

fn handle_get_result(
  result: PogResult(row_type),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(Option(domain_type)) {
  case result.map(result, fn(x) { x.rows }) {
    Ok([]) -> Ok(option.None)
    Ok([row]) -> Ok(option.Some(constructor(row)))
    Ok(_) -> Error(MultipleGetError)
    Error(x) -> Error(PogError(x))
  }
}

pub fn run_get_query(
  query_fn: QueryFn(row_type),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(Option(domain_type)) {
  utils.get_pog_connection() |> query_fn() |> handle_get_result(constructor)
}

fn handle_nil_result(result: PogResult(Nil)) -> DAOResult(Nil) {
  case result {
    Ok(_) -> Ok(Nil)
    Error(x) -> Error(PogError(x))
  }
}

pub fn run_nil_query(query_fn: QueryFn(_)) -> DAOResult(Nil) {
  utils.get_pog_connection() |> query_fn() |> handle_nil_result()
}

fn handle_list_result(
  result: PogResult(row_type),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(List(domain_type)) {
  case result {
    Ok(ret) -> Ok(ret.rows |> list.map(constructor))
    Error(x) -> Error(PogError(x))
  }
}

pub fn run_list_query(
  query_fn: QueryFn(row_type),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(List(domain_type)) {
  utils.get_pog_connection() |> query_fn() |> handle_list_result(constructor)
}
