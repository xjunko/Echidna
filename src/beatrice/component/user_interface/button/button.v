module button

import gg
import gx
import src.beatrice.component.user_interface.common
import src.beatrice.component.object
import src.beatrice.math.vector
import src.beatrice.graphic.backend

pub struct Button {
	common.BaseInteractible
mut:
	border_color     object.GameObjectColor[f64] = object.GameObjectColor[f64]{255, 255, 255, 255}
	background_color object.GameObjectColor[f64] = object.GameObjectColor[f64]{0, 0, 0, 255}
pub mut:
	is_clicked bool
	text       string
}

pub fn (mut button Button) init(mut ctx gg.Context) {}

pub fn (mut button Button) on_click(typ common.MouseButton, pos vector.Vector2[f64]) {
	if button.is_aabb_inside(pos) {
		button.BaseInteractible.on_click(typ, pos) // Call callbacks
		button.is_clicked = true

		button.border_color.r = 100
		button.border_color.g = 100
		button.border_color.b = 100
	}
}

pub fn (mut button Button) on_unclick(typ common.MouseButton, pos vector.Vector2[f64]) {
	// inside || clicked outside but button has been pressed before
	if (button.is_aabb_inside(pos)) || (!button.is_aabb_inside(pos) && button.is_clicked) {
		button.BaseInteractible.on_unclick(typ, pos) // Call callbacks
		button.is_clicked = false

		button.border_color.r = 255
		button.border_color.g = 255
		button.border_color.b = 255
	}
}

pub fn (mut button Button) is_aabb_inside(pos vector.Vector2[f64]) bool {
	size := button.size
	position := button.position
		.sub(button.origin.Vector2.multiply(size))

	// FIXME: This doesnt add account for offset
	return (pos.x >= position.x && pos.x <= position.add(size).x)
		&& (pos.y >= position.y && pos.y <= position.add(size).y)
}

pub fn (mut button Button) draw(arg backend.DrawConfig) {
	size := button.size
		.scale(arg.scale)

	position := button.position
		.scale(arg.scale)
		.sub(button.origin.Vector2.multiply(size))
		.add(arg.offset)

	// Background
	arg.backend.draw_rect_filled(position.x, position.y, size.x, size.y, button.background_color)

	// Outline
	arg.backend.draw_rect_empty(position.x, position.y, size.x, size.y, button.border_color)

	// Text
	arg.backend.draw_text(int(position.x + size.x / 2.0), int(position.y + size.y / 2.0 - 20 / 2),
		button.text, gx.TextCfg{
		align: .center
		color: gx.white
		size: 20
	})
}
