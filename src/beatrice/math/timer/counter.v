module timer

import time

pub struct TimeCounter {
mut:
	start_time f64
	last_time  f64
pub mut:
	delta f64
	time  f64
	fps   f64
	speed f64 = 1.0
}

pub fn (mut t TimeCounter) reset() {
	t.last_time = time.ticks()
	t.start_time = t.last_time
	t.time = 0
	t.delta = 0
	t.fps = 0
}

pub fn (mut t TimeCounter) tick() f64 {
	now := time.ticks()

	t.delta = now - t.last_time
	t.time = (now - t.start_time) * t.speed
	t.last_time = now

	t.fps = 1000.0 / t.delta

	return t.delta
}

pub fn (mut t TimeCounter) get_elapsed_time() f64 {
	return t.time
}
