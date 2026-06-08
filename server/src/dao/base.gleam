//// Basic/Generic definitions for the DAOs

import envoy
import gleam/erlang/process
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

pub fn run_get_query(
  query_fn: QueryFn(row_type),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(Option(domain_type)) {
  get_pog_connection() |> query_fn() |> handle_get_result(constructor)
}

fn handle_get_result(
  result: PogResult(row_type),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(Option(domain_type)) {
  case result.map(result, fn(x) { x.rows }) {
    Ok([]) -> Ok(option.None)
    Ok([row]) -> Ok(option.Some(constructor(row)))
    Ok(_) -> Error(MultipleGetError)
    Error(err) -> Error(PogError(err))
  }
}

pub fn run_nil_query(query_fn: QueryFn(_)) -> DAOResult(Nil) {
  get_pog_connection() |> query_fn() |> handle_nil_result()
}

fn handle_nil_result(result: PogResult(Nil)) -> DAOResult(Nil) {
  case result {
    Ok(_) -> Ok(Nil)
    Error(err) -> Error(PogError(err))
  }
}

pub fn run_list_query(
  query_fn: QueryFn(row_type),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(List(domain_type)) {
  get_pog_connection() |> query_fn() |> handle_list_result(constructor)
}

fn handle_list_result(
  result: PogResult(row_type),
  constructor: fn(row_type) -> domain_type,
) -> DAOResult(List(domain_type)) {
  case result {
    Ok(ret) -> Ok(ret.rows |> list.map(constructor))
    Error(err) -> Error(PogError(err))
  }
}

pub fn run_check_query(
  query_fn: QueryFn(row_type),
  constructor: fn(row_type) -> Bool,
) {
  get_pog_connection() |> query_fn() |> handle_check_result(constructor)
}

fn handle_check_result(
  result: PogResult(row_type),
  constructor: fn(row_type) -> Bool,
) -> DAOResult(Bool) {
  case result {
    Ok(x) -> {
      case x.rows {
        [x] -> Ok(constructor(x))
        _ -> Ok(False)
      }
    }
    Error(err) -> Error(PogError(err))
  }
}

fn get_pog_connection() -> pog.Connection {
  let db_pool_name = process.new_name("db_pool")
  let assert Ok(database_url) = envoy.get("DATABASE_URL")
  let assert Ok(pog_config) = pog.url_config(db_pool_name, database_url)
  let assert Ok(_) =
    pog_config
    |> pog.pool_size(10)
    |> pog.start

  pog.named_connection(db_pool_name)
}
