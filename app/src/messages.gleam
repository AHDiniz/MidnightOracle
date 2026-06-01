import midnight_domain/user.{type User}

pub type Page {
  Login
  Register
  Error
}

pub type Model {
  Model(user: User, token: Int, current_page: Page)
}

pub type Message {
  SetUserName(username: String)
  SetUserEmail(email: String)
  SetPassword(password: String)
  UserLogin
  UserRegister
  GoToPage(page: Page)
}
