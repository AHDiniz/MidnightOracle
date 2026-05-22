import midnight_domain/user.{type User}

pub type Model {
  Model(user: User, logged_in: Bool)
}

pub type Message {
  SetUserName(username: String)
  SetUserEmail(email: String)
  SetPassword(password: String)
  UserLogin
}
