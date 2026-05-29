import auth_view
import lustre
import lustre/attribute as attr
import lustre/effect
import lustre/element.{text}
import lustre/element/html
import lustre/event
import messages as msg
import midnight_domain/user.{User}

fn init(model: msg.Model) {
  #(model, effect.none())
}

fn update(model: msg.Model, message: msg.Message) {
  case message {
    msg.SetUserName(username) -> {
      let next_user =
        User(
          username: username,
          email: model.user.email,
          password: model.user.password,
        )
      let next_model = msg.Model(next_user, -1)
      #(next_model, effect.none())
    }
    msg.SetUserEmail(email) -> {
      let next_user =
        User(
          username: model.user.username,
          email: email,
          password: model.user.password,
        )
      let next_model = msg.Model(next_user, -1)
      #(next_model, effect.none())
    }
    msg.SetPassword(password) -> {
      let next_user =
        User(
          username: model.user.username,
          email: model.user.email,
          password: password,
        )
      let next_model = msg.Model(next_user, -1)
      #(next_model, effect.none())
    }
    msg.UserLogin -> {
      let next_model = msg.Model(model.user, -1)
      #(model, effect.none())
    }
    msg.GoToPage(page) -> {
      case page {
        _ -> {
          #(model, effect.none())
        }
      }
    }
  }
}

fn view(model: msg.Model) {
  case model.token {
    -1 -> {
      auth_view.login_form(model)
    }
    _ -> {

    }
  }
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let user = User(username: "", email: "", password: "")
  let model = msg.Model(user, -1)
  let assert Ok(_) = lustre.start(app, "div", model)

  Nil
}
