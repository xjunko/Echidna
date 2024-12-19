module sprite

import beatrice.engine.renderer

pub struct Manager {
mut:
	last_time f64
pub mut:
	queue     []&Sprite
	drawing   []&Sprite
	processed []&Sprite
}

pub fn (mut manager Manager) add(mut sprite Sprite) {
	manager.queue << unsafe { &sprite }
	manager.queue.sort(a.time.start < b.time.start)
}

pub fn (mut manager Manager) update(time f64) {
	manager.last_time = time
	time_to_catch_up := 100.0

	for mut cur_sprite in manager.queue {
		if time >= cur_sprite.time.start - time_to_catch_up || cur_sprite.is_available_at(time)
			|| cur_sprite.always_visible {
			manager.drawing << manager.queue[manager.queue.index(cur_sprite)]
			manager.queue.delete(manager.queue.index(cur_sprite))
			continue
		}
	}

	for mut cur_sprite in manager.drawing {
		if time >= cur_sprite.time.end && !cur_sprite.always_visible {
			manager.processed << manager.drawing[manager.drawing.index(cur_sprite)]
			manager.drawing.delete(manager.drawing.index(cur_sprite))
			continue
		}

		if cur_sprite.is_available_at(time) || cur_sprite.always_visible {
			cur_sprite.update(time)
		}
	}
}

pub fn (mut manager Manager) draw(mut graphics renderer.IRenderer) {
	mut draw_count := 0

	for mut sprite in manager.drawing {
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
