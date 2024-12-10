module sprite

import beatrice.engine.renderer

pub struct Manager {
mut:
	last_time f64
pub mut:
	queue     []&Sprite
	processed []&Sprite
}

pub fn (mut manager Manager) add(mut sprite Sprite) {
	manager.queue << unsafe { &sprite }
	manager.queue.sort(a.time.start < b.time.start)
}

pub fn (mut manager Manager) update(time f64) {
	manager.last_time = time

	for mut sprite in manager.queue {
		// Remove if old
		if time >= sprite.time.end && !sprite.always_visible {
			manager.queue.delete(manager.queue.index(sprite))
			continue
		}

		if sprite.is_available_at(time) || sprite.always_visible {
			sprite.update(time)
		}
	}
}

pub fn (mut manager Manager) draw(mut graphics renderer.IRenderer) {
	mut draw_count := 0

	for mut sprite in manager.queue {
		if sprite.is_available_at(manager.last_time) || sprite.always_visible {
			draw_count++
			sprite.draw(mut graphics)
		}
	}
}

// Factory
pub fn new_manager() &Manager {
	mut manager := &Manager{}

	return manager
}
