import auth_view
import control as ctrl
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
    msg.GoToPage(page) -> {
      let next_model = msg.Model(model.user, -1, page)
      #(next_model, effect.none())
    }
    _ -> {
      case model.current_page {
        msg.Login -> {
          ctrl.login_update(model, message)
        }
        msg.Register -> {
          ctrl.register_update(model, message)
        }
        msg.Error -> {
          #(model, effect.none())
        }
      }
    }
  }
}

fn view(model: msg.Model) {
  case model.current_page {
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
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let user = User(username: "", email: "", password: "")
  let model = msg.Model(user, -1, msg.Login)
  let assert Ok(_) = lustre.start(app, "div", model)

  Nil
}
