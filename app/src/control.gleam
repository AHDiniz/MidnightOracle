import application as app
import gleam/dynamic/decode
import gleam/http/response
import lustre/effect
import messages as msg
import midnight_domain/user
import rsvp

pub fn login_update(
  model: msg.Model,
  message: msg.Message,
) -> #(msg.Model, effect.Effect(msg.Message)) {
  case message {
    msg.SetUserName(username) -> {
      let next_user =
        user.User(
          username: username,
          email: model.user.email,
          password: model.user.password,
        )
      let next_model = msg.Model(next_user, "", model.current_page)
      #(next_model, effect.none())
    }
    msg.SetPassword(password) -> {
      let next_user =
        user.User(
          username: model.user.username,
          email: model.user.email,
          password: password,
        )
      let next_model = msg.Model(next_user, "", model.current_page)
      #(next_model, effect.none())
    }
    msg.UserLogin -> {
      #(model, app.login_service(model.user))
    }
    _ -> {
      #(model, effect.none())
    }
  }
}

pub fn register_update(
  model: msg.Model,
  message: msg.Message,
) -> #(msg.Model, effect.Effect(msg.Message)) {
  case message {
    msg.SetUserName(username) -> {
      let next_user =
        user.User(
          username: username,
          email: model.user.email,
          password: model.user.password,
        )
      let next_model = msg.Model(next_user, "", model.current_page)
      #(next_model, effect.none())
    }
    msg.SetUserEmail(email) -> {
      let next_user =
        user.User(
          username: model.user.username,
          email: email,
          password: model.user.password,
        )
      let next_model = msg.Model(next_user, "", model.current_page)
      #(next_model, effect.none())
    }
    msg.SetPassword(password) -> {
      let next_user =
        user.User(
          username: model.user.username,
          email: model.user.email,
          password: password,
        )
      let next_model = msg.Model(next_user, "", model.current_page)
      #(next_model, effect.none())
    }
    msg.UserRegister -> {
      #(model, app.register_service(model.user))
    }
    _ -> {
      #(model, effect.none())
    }
  }
}

pub fn treat_login_message(
  model: msg.Model,
  result: Result(String, rsvp.Error(String)),
) -> #(msg.Model, effect.Effect(msg.Message)) {
  case result {
    Ok(_) -> {
      #(model, effect.none())
    }
    Error(_) -> {
      #(model, effect.from(msg.error_dispatch))
    }
  }
}

pub fn treat_register_message(
  model: msg.Model,
  result: Result(response.Response(String), rsvp.Error(String)),
) -> #(msg.Model, effect.Effect(msg.Message)) {
  case result {
    Ok(_) -> {
      #(model, effect.none())
    }
    Error(_) -> {
      #(model, effect.from(msg.error_dispatch))
    }
  }
}

pub fn treat_go_to_page_message(
  model: msg.Model,
  page: msg.Page,
) -> #(msg.Model, effect.Effect(msg.Message)) {
  let next_model = msg.Model(model.user, model.token, page)
  #(next_model, effect.none())
}

pub fn update_pages(model: msg.Model, message: msg.Message) -> #(msg.Model, effect.Effect(msg.Message)) {
  case model.current_page {
    msg.Login -> login_update(model, message)
    msg.Register -> register_update(model, message)
    msg.Error -> #(model, effect.none())
  }
}
