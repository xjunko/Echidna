module button

import gx
import src.beatrice.component.user_interface_naive.common
import src.beatrice.component.object
import src.beatrice.graphic.backend
import src.beatrice.math.vector

pub struct BaseButton {
	common.BaseUIElement
pub mut:
	draw_frame      bool = true
	draw_background bool = true

	frame_color       object.GameObjectColor[f64] = object.GameObjectColor[f64]{255.0, 255.0, 255.0, 255.0}
	background_color  object.GameObjectColor[f64] = object.GameObjectColor[f64]{255.0, 0.0, 0.0, 255.0}
	text_color        object.GameObjectColor[f64] = object.GameObjectColor[f64]{255.0, 255.0, 255.0, 255.0}
	text_bright_color object.GameObjectColor[f64] = object.GameObjectColor[f64]{0.0, 0.0, 0.0, 255.0}

	text      string = 'Balls'
	text_size int    = 32
}

pub fn (mut element BaseButton) on_mouse_inside(pos vector.Vector2[f64]) {
	println('INherited')
	element.BaseUIElement.on_mouse_inside(pos)
}

pub fn (mut button BaseButton) draw(arg backend.DrawConfig) {
	if !button.is_visible {
		return
	}

	// Background
	if button.draw_background {
		arg.backend.draw_rect_filled(button.position.x, button.position.y, button.size.x,
			button.size.y, button.background_color)
	}

	// Frame
	if button.draw_frame {
		arg.backend.draw_rect_empty(button.position.x, button.position.y, button.size.x,
			button.size.y, button.frame_color)
	}

	arg.backend.draw_text(button.position.x + button.size.x / 2.0, button.position.y +
		button.size.y / 2.0 - (f64(button.text_size) / 2.0), button.text, gx.TextCfg{
		color: gx.white
		align: .center
		size: button.text_size
	})
}
