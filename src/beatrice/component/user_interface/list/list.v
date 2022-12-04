module list

import src.beatrice.component.user_interface.common
import src.beatrice.component.object
import src.beatrice.math.vector
import src.beatrice.component.user_interface.button
import src.beatrice.graphic.backend

const (
	bumfuck_nowhere = vector.Vector2[f64]{-420.69, -420.69}
)

pub struct ComponentList {
	common.BaseInteractible
mut:
	is_clicked bool

	border_color     object.GameObjectColor[f64] = object.GameObjectColor[f64]{255, 255, 255, 255}
	background_color object.GameObjectColor[f64] = object.GameObjectColor[f64]{100, 0, 0, 100}
pub mut:
	components []common.IInteractible
}

pub fn (mut component_list ComponentList) on_click(typ common.MouseButton, pos vector.Vector2[f64]) {
	if component_list.is_aabb_inside(pos) {
		component_list.BaseInteractible.on_click(typ, pos) // Call callbacks
		component_list.is_clicked = true

		component_list.border_color.r = 100
		component_list.border_color.g = 100
		component_list.border_color.b = 100

		// Do some black magic offsetting to get "internal" position
		// pos_local := pos.sub(component_list.position.sub(component_list.origin.Vector2.multiply(component_list.size)))
	}
}

pub fn (mut component_list ComponentList) on_unclick(typ common.MouseButton, pos vector.Vector2[f64]) {
	if component_list.is_aabb_inside(pos)
		|| (!component_list.is_aabb_inside(pos) && component_list.is_clicked) {
		component_list.BaseInteractible.on_unclick(typ, pos) // Call callbacks
		component_list.is_clicked = false

		component_list.border_color.r = 255
		component_list.border_color.g = 255
		component_list.border_color.b = 255
	}
}

pub fn (mut component_list ComponentList) draw(arg backend.DrawConfig) {
	size := component_list.size
		.scale(arg.scale)

	position := component_list.position
		.scale(arg.scale)
		.sub(component_list.origin.Vector2.multiply(size))
		.add(arg.offset)

	// Background
	arg.backend.draw_rect_filled(position.x, position.y, size.x, size.y, component_list.background_color)

	// Outline
	arg.backend.draw_rect_empty(position.x, position.y, size.x, size.y, component_list.border_color)

	// Components
	mut y := 0.0
	for mut c in component_list.components {
		if mut c is button.Button {
			c.draw(backend.DrawConfig{
				...arg
				offset: vector.Vector2[f64]{
					x: -c.position.x + (position.x + (c.size.x / 2))
					y: -c.position.y + (position.y + y + (c.size.y / 2))
				}
			})
			y += c.size.y
		}
	}
}
