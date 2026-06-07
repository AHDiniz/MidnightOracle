import gleam/http/response
import midnight_domain/user
import rsvp

pub type Page {
  Login
  Register
  Error
}

pub type Model {
  Model(user: user.User, token: String, current_page: Page)
}

pub type Message {
  SetUserName(username: String)
  SetUserEmail(email: String)
  SetPassword(password: String)
  UserLogin
  UserRegister
  GoToPage(page: Page)
  ApiLoginRequest(result: Result(String, rsvp.Error(String)))
  ApiRegisterRequest(
    result: Result(response.Response(String), rsvp.Error(String)),
  )
}

pub fn error_dispatch(dispatch) {
  dispatch(GoToPage(Error))
}
