import application as app
import lustre/effect
import messages as msg
import midnight_domain/user

pub fn login_update(model: msg.Model, message: msg.Message) -> #(msg.Model, effect.Effect(msg.Message)) {
  case message {
    msg.SetUserName(username) -> {
      let next_user =
        user.User(
          username: username,
          email: model.user.email,
          password: model.user.password,
        )
      let next_model = msg.Model(next_user, -1, model.current_page)
      #(next_model, effect.none())
    }
    msg.SetPassword(password) -> {
      let next_user =
        user.User(
          username: model.user.username,
          email: model.user.email,
          password: password,
        )
      let next_model = msg.Model(next_user, -1, model.current_page)
      #(next_model, effect.none())
    }
    msg.UserLogin -> {
      let next_model = login_controller(model)
      #(next_model, effect.none())
    }
    _ -> {
      #(model, effect.none())
    }
  }
}

pub fn register_update(model: msg.Model, message: msg.Message) -> #(msg.Model, effect.Effect(msg.Message)) {
  case message {
    msg.SetUserName(username) -> {
      let next_user =
        user.User(
          username: username,
          email: model.user.email,
          password: model.user.password,
        )
      let next_model = msg.Model(next_user, -1, model.current_page)
      #(next_model, effect.none())
    }
    msg.SetUserEmail(email) -> {
      let next_user =
        user.User(
          username: model.user.username,
          email: email,
          password: model.user.password,
        )
      let next_model = msg.Model(next_user, -1, model.current_page)
      #(next_model, effect.none())
    }
    msg.SetPassword(password) -> {
      let next_user =
        user.User(
          username: model.user.username,
          email: model.user.email,
          password: password,
        )
      let next_model = msg.Model(next_user, -1, model.current_page)
      #(next_model, effect.none())
    }
    msg.UserRegister -> {
      let next_model = register_controller(model)
      #(next_model, effect.none())
    }
    _ -> {
      #(model, effect.none())
    }
  }
}

pub fn login_controller(model: msg.Model) -> msg.Model {
  let try_user = app.login_service(model.user)

  let next_model = case try_user {
    Error(_) -> {
      model
    }
    Ok(user) -> {
      let next_model = msg.Model(user, -1, model.current_page)
      next_model
    }
  }

  next_model
}

pub fn register_controller(model: msg.Model) -> msg.Model {
  let try_user = app.register_service(model.user)

  let next_model = case try_user {
    Error(_) -> {
      model
    }
    Ok(user) -> {
      let next_model = msg.Model(user, -1, model.current_page)
      next_model
    }
  }

  next_model
}
