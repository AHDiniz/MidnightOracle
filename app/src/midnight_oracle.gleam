import app_view
import auth_view
import control as ctrl
import lustre
import lustre/effect
import lustre/element
import lustre/element/html
import messages as msg
import midnight_domain/user

fn init(model: msg.Model) {
  #(model, effect.none())
}

fn update(
  model: msg.Model,
  message: msg.Message,
) -> #(msg.Model, effect.Effect(msg.Message)) {
  echo model
  let #(next_model, e) = case message {
    msg.ApiLoginRequest(result) -> ctrl.treat_login_message(model, result)
    msg.ApiRegisterRequest(result) -> ctrl.treat_register_message(model, result)
    msg.GoToPage(page) -> ctrl.treat_go_to_page_message(model, page)
    _ -> ctrl.update_pages(model, message)
  }
  echo next_model
  #(next_model, e)
}

fn view(model: msg.Model) -> element.Element(msg.Message) {
  let content = case model.current_page {
    msg.Login -> {
      auth_view.login_form(model)
    }
    msg.Register -> {
      auth_view.register_form(model)
    }
    _ -> {
      html.div([], [])
    }
  }
  app_view.app_wrapper(model, content)
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let user = user.User(username: "", email: "", password: "")
  let model = msg.Model(user, "", msg.Login)
  let assert Ok(_) = lustre.start(app, "#app", model)

  Nil
}
