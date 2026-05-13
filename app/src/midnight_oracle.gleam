import lustre
import lustre/attribute as attr
import lustre/effect
import lustre/element.{text}
import lustre/element/html
import lustre/event
import messages as msg
import midnight_domain/user.{User}

fn init(model: msg.Model) {
  let user = User(username: "", email: "", password: "")
  #(msg.Model(user), effect.none())
}

fn update(model: msg.Model, message: msg.Message) {
  case message {
    msg.SetUserName(username) -> {
      #(model, effect.none())
    }
    msg.SetUserEmail(email) -> {
      #(model, effect.none())
    }
    msg.SetPassword(password) -> {
      #(model, effect.none())
    }
    msg.UserLogin -> {
      #(model, effect.none())
    }
  }
}

fn view(model: msg.Model) {
  let user = model.user
  html.div([], [
    html.div([], [
      html.input([attr.value(user.username), event.on_input(msg.SetUserName)]),
    ]),
    html.div([], [
      html.input([attr.value(user.email), event.on_input(msg.SetUserEmail)]),
    ]),
    html.div([], [
      html.input([attr.value(user.password), event.on_input(msg.SetPassword)]),
    ]),
    html.div([], [html.button([event.on_click(msg.UserLogin)], [text("Login")])]),
  ])
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "div", Nil)

  Nil
}
