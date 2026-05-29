import application as app
import messages as msg
import midnight_domain/user.{type User, User}

pub fn login_controller(model: msg.Model) -> msg.Model {
  let try_user = app.login_service(model.user)

  let next_model = case try_user {
    Error(_) -> {
      model
    }
    Ok(user) -> {
      let next_model = msg.Model(user, -1)
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
      let next_model = msg.Model(user, -1)
      next_model
    }
  }

  next_model
}
