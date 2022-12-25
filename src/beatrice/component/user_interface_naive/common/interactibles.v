module common

import src.beatrice.math.vector
import src.beatrice.graphic.backend
import src.beatrice.component.object
import src.beatrice.graphic.window.input

pub interface IUIElement {
mut:
	is_visible bool
	is_active bool
	is_enabled bool
	update(f64, vector.Vector2[f64], input.ButtonType, input.InputState)
	draw(backend.DrawConfig)
}

pub struct BaseUIElement {
	object.GameObject
mut:
	mouse_up_check     bool
	mouse_inside_check bool
pub mut:
	is_visible bool = true
	is_active  bool
	is_enabled bool = true

	is_mouse_inside bool
}

pub fn (mut element BaseUIElement) contain(pos vector.Vector2[f64]) bool {
	return pos.x >= element.position.x && pos.x <= element.position.x + element.size.x
		&& pos.y >= element.position.y && pos.y <= element.position.y + element.size.y
}

pub fn (mut element BaseUIElement) on_mouse_inside(pos vector.Vector2[f64]) {
	println('Inside')
}

pub fn (mut element BaseUIElement) on_mouse_outside(pos vector.Vector2[f64]) {
	println('Out')
}

pub fn (mut element BaseUIElement) on_mouse_up_inside(pos vector.Vector2[f64]) {
	println('UnClick in')
}

pub fn (mut element BaseUIElement) on_mouse_up_outside(pos vector.Vector2[f64]) {
	println('UnClick out')
}

pub fn (mut element BaseUIElement) on_mouse_down_inside(pos vector.Vector2[f64]) {
	println('Click in')
}

pub fn (mut element BaseUIElement) on_mouse_down_outside(pos vector.Vector2[f64]) {
	println('Click out')
}

pub fn (mut element BaseUIElement) update(time f64, pos vector.Vector2[f64], button input.ButtonType, state input.InputState) {
	element.last_update = time

	if element.contain(pos) {
		if !element.is_mouse_inside {
			element.is_mouse_inside = true

			if element.is_visible && element.is_enabled {
				element.on_mouse_inside(pos)
			}
		}
	} else {
		if element.is_mouse_inside {
			element.is_mouse_inside = false

			if element.is_visible && element.is_enabled {
				element.on_mouse_outside(pos)
			}
		}
	}

	if !element.is_visible || !element.is_enabled {
		return
	}

	if button == .mouse_left && state == .mouse_click {
		element.mouse_up_check = true

		// Down out
		if !element.is_mouse_inside && !element.mouse_inside_check {
			element.mouse_inside_check = true
			element.on_mouse_down_outside(pos)
		}

		// Down in
		if element.is_mouse_inside && !element.mouse_inside_check {
			element.is_active = true
			element.mouse_inside_check = true
			element.on_mouse_down_inside(pos)
		}
	} else {
		if element.mouse_up_check {
			if element.is_active {
				if element.is_mouse_inside {
					element.on_mouse_up_inside(pos)
				} else {
					element.on_mouse_up_outside(pos)
				}
			}
		}

		element.mouse_inside_check = false
		element.mouse_up_check = false
	}
}
