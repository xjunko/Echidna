module user_interface

import src.beatrice.component.user_interface.common
import src.beatrice.math.vector
import src.beatrice.graphic.backend

pub struct Manager {
mut:
	last_time f64
pub mut:
	elements []common.IInteractible
}

pub fn (mut manager Manager) add(mut element common.IInteractible) {
	manager.elements << unsafe { element }
}

pub fn (mut manager Manager) update(time f64) {
	for mut element in manager.elements {
		element.update(time)
	}
}

pub fn (mut manager Manager) draw(arg backend.DrawConfig) {
	for mut element in manager.elements {
		element.draw(arg)
	}
}

// Events
pub fn (mut manager Manager) on_click(typ common.MouseButton, pos vector.Vector2[f64]) {
	for mut element in manager.elements {
		// Maybe do a AABB check here beforehand?
		element.on_click(typ, pos)
	}
}

pub fn (mut manager Manager) on_unclick(typ common.MouseButton, pos vector.Vector2[f64]) {
	for mut element in manager.elements {
		// Maybe do a AABB check here beforehand?
		element.on_unclick(typ, pos)
	}
}

// Factory
pub fn new_manager() &Manager {
	mut manager := &Manager{}

	return manager
}
