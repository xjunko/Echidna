module user_interface_naive

import src.beatrice.component.user_interface_naive.common
import src.beatrice.math.vector
import src.beatrice.graphic.backend
import src.beatrice.graphic.window.input

pub struct Manager {
mut:
	last_time      f64
	last_mouse_pos vector.Vector2[f64]
pub mut:
	elements []common.IUIElement
}

pub fn (mut manager Manager) add(mut element common.IUIElement) {
	manager.elements << unsafe { element }
}

pub fn (mut manager Manager) update(time f64) {
	// for mut element in manager.elements {
	// 	element.update(time, manager.last_mouse_pos, .mouse_left, .nothing)
	// }
}

pub fn (mut manager Manager) draw(arg backend.DrawConfig) {
	for mut element in manager.elements {
		element.draw(arg)
	}
}

// Events
pub fn (mut manager Manager) on_click(typ input.ButtonType, pos vector.Vector2[f64]) {
	manager.last_mouse_pos = pos

	for mut element in manager.elements {
		element.update(manager.last_time, pos, typ, .mouse_click)
	}
}

pub fn (mut manager Manager) on_unclick(typ input.ButtonType, pos vector.Vector2[f64]) {
	manager.last_mouse_pos = pos

	for mut element in manager.elements {
		element.update(manager.last_time, pos, typ, .mouse_unclick)
	}
}

// Factory
pub fn new_manager() &Manager {
	mut manager := &Manager{}

	return manager
}
