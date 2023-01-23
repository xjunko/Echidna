module transform

import beatrice.math.time
import beatrice.math.vector
import beatrice.math.easing

pub enum TransformType {
	move
	angle
	fade
	scale
	scale_by_factor
	scale_by_vector
	// Backward compatibility
	move_x
	move_y
	scale_factor
}

pub struct Transform[T] {
pub mut:
	typ    TransformType         [required]
	easing easing.EasingFunction = easing.linear
	time   time.Time[T]
	before []T                   [required]
	after  []T
}

pub fn (transform Transform[T]) str() string {
	return 'Transform<${typeof(transform.time.start).name}>{type=${transform.typ}, time=${transform.time}}'
}

pub fn (t Transform[T]) as_one(time T) T {
	return T(t.easing(time - t.time.start, t.before[0], t.after[0] - t.before[0], t.time.duration()))
}

pub fn (t Transform[T]) as_two(time T) []T {
	return [
		T(t.easing(time - t.time.start, t.before[0], t.after[0] - t.before[0], t.time.duration())),
		T(t.easing(time - t.time.start, t.before[1], t.after[1] - t.before[1], t.time.duration())),
	]
}

pub fn (t Transform[T]) as_vector(time T) vector.Vector2[T] {
	// TODO: skull
	v := t.as_two(time)

	return vector.Vector2[T]{
		x: v[0]
		y: v[1]
	}
}

// Utils
pub fn (mut t Transform[T]) ensure_both_slots_is_filled_in() {
	if t.after.len != t.before.len {
		t.after = t.before.clone()
	}
}

pub fn (t Transform[T]) clone() Transform[T] {
	return Transform[T]{
		...t
	}
}
