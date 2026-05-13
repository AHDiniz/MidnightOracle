import midnight_domain/user.{type User}

pub type Model {
  Model(user: User)
}

pub type Message {
  SetUserName(username: String)
  SetUserEmail(email: String)
  SetPassword(password: String)
  UserLogin
}
