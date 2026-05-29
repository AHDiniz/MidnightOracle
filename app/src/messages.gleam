import midnight_domain/user.{type User}

pub type Page {
  Login
  Register
  Error
}

pub type Model {
  Model(user: User, token: Int)
}

pub type Message {
  SetUserName(username: String)
  SetUserEmail(email: String)
  SetPassword(password: String)
  UserLogin
  GoToPage(page : Page)
}
