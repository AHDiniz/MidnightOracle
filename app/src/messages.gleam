import midnight_domain/user

pub type Page {
  Login
  Register
  Error
}

pub type Model {
  Model(user: user.User, token: Int, current_page: Page)
}

pub type Message {
  SetUserName(username: String)
  SetUserEmail(email: String)
  SetPassword(password: String)
  UserLogin
  UserRegister
  GoToPage(page: Page)
  ApiLoginResponse(user: user.User, token: Int)
  ApiRegisterResponse(user: user.User, token: Int)
}
