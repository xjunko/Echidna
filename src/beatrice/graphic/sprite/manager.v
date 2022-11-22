module sprite

import gg
import gx
import arrays

pub struct Manager {
	mut:
		last_time f64
		experimental bool = true

	pub mut:
		queue []&Sprite
		processed []&Sprite
}

pub fn (mut manager Manager) add(mut sprite Sprite) {
	manager.queue << unsafe { &sprite }
	manager.queue.sort(a.time.start < b.time.start)
}

pub fn (mut manager Manager) update(time f64) {
	if manager.experimental { manager.update_experimental(time) return }

	manager.last_time = time

	for mut sprite in manager.queue {
		// Remove if old
		if time >= sprite.time.end {
			manager.queue.delete(manager.queue.index(sprite))
			continue
		}

		if sprite.is_available_at(time) {
			sprite.update(time)
		}
	}
}

pub fn (mut manager Manager) update_experimental(time f64) {
	manager.last_time = time

	mut to_remove := 0

	for i := 0; i < manager.queue.len; i++ {
		mut c := unsafe { manager.queue[i] }

		if time < c.time.start {
			break
		}

		to_remove++
	}

	if to_remove > 0 {
		for i := 0; i < to_remove; i++ {
			mut s := unsafe { manager.queue[i] }

			manager.processed << &Sprite{}
			arrays.copy(mut manager.processed[1 .. ], manager.processed[ 0 .. ])

			manager.processed[0] = s
		}

		manager.queue = manager.queue[to_remove .. ]
	}

	for i := 0; i < manager.processed.len; i++ {
		mut c := unsafe { manager.processed[i] }

		c.update(time)

		if time >= c.time.end {
			arrays.copy(mut manager.processed[i .. ], manager.processed[i+1 .. ])
			manager.processed = manager.processed[ .. manager.processed.len - 1]

			i--
		}
	}
}

pub fn (mut manager Manager) draw(ctx &gg.Context) {
	if manager.experimental { manager.draw_experimental(ctx) return }

	mut draw_count := 0

	for mut sprite in manager.queue {
		if sprite.is_available_at(manager.last_time) {
			draw_count++
			sprite.draw(ctx)
		}
	}

	ctx.draw_text(20, 50, "Manager: ${draw_count} drawing", gx.TextCfg{color: gx.white, size: 30})
}

pub fn (mut manager Manager) draw_experimental(ctx &gg.Context) {
	for i := manager.processed.len - 1; i >= 0; i-- {
		manager.processed[i].draw(ctx)
	}

	ctx.draw_text(20, 50, "Manager: ${manager.processed.len} drawing", gx.TextCfg{color: gx.white, size: 30})
}

// Factory
pub fn new_manager() &Manager {
	mut manager := &Manager{}

	return manager
}