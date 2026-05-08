import gleam/erlang/process.{type Name}
import midnight_domain.{type User}
import pog

pub fn get_user_by_username(username: String) -> Nil {
  let conn = pog.named_connection(Name(pog.Message()))
}
