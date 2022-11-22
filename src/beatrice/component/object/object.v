module object

import math

import beatrice.math.vector
import beatrice.math.time
import beatrice.math.transform

pub struct GameObjectColor<T> {
	pub mut:
		r T
		g T
		b T
		a T
}

// GameObject is a common object idk what to say tbh, its a common thing.
pub struct GameObject {
	mut:
		texture_size vector.Vector2<f64> = vector.Vector2<f64>{1.0, 1.0} // 1x1 by default, to be replace by the sprite texture size.

	pub mut:
		time time.Time<f64>
		transforms []transform.Transform<f64>

		// Transform attributes
		position vector.Vector2<f64>
		size     vector.Vector2<f64>
		color    GameObjectColor<f64> = GameObjectColor<f64>{255.0, 255.0, 255.0, 255.0}
}

// Updates
const (
	hack_time_to_catch_up = 100.0
)

pub fn (mut object GameObject) update(time f64) {
	// TODO: improve this
	for t in object.transforms {
		if time >= t.time.start && time <= t.time.end + hack_time_to_catch_up {
			object.apply_event(t, math.min<f64>(time, t.time.end))
		}
	}
}

// Transforms
pub fn (mut object GameObject) apply_event(t transform.Transform<f64>, time f64) {
	match t.typ {
		.move {
			pos := t.as_vector(time)
			object.position.x = pos.x
			object.position.y = pos.y
		}

		.move_x {
			object.position.x = t.as_one(time)
		}

		.move_y {
			object.position.y = t.as_one(time)
		}

		.fade {
			object.color.a = t.as_one(time)
		}

		.scale {
			v := t.as_vector(time)
			object.size.x = object.texture_size.x * v.x
			object.size.y = object.texture_size.y * v.y
		}

		.scale_by_factor, .scale_factor {
			f := t.as_one(time)
			object.size.x = object.texture_size.x * f
			object.size.y = object.texture_size.y * f
		}

		.scale_by_vector{
			v := t.as_vector(time)
			object.size.x = v.x
			object.size.y = v.y
		}

		else {}
	}
}

pub fn (mut object GameObject) add_transform(t0 transform.Transform<f64>) {
	if t0.before.len != t0.after.len {
		mut t := t0.clone()
		t.ensure_both_slots_is_filled_in()
		object.transforms << t
	} else {
		object.transforms << t0
	}
}

// Resets
pub fn (mut object GameObject) reset_attributes_based_on_transforms() {
	mut applied := []transform.TransformType{}

	// This function usually only ran once, so 
	// lets just sort the whole thing.
	object.transforms.sort(a.time.start < b.time.start)

	for i, t in object.transforms {
		// Reset time if first object
		if i == 0 {
			object.time.start = t.time.start
		}

		// Start end time
		object.time.start = math.min<f64>(object.time.start, t.time.start)
		object.time.end = math.max<f64>(object.time.end, t.time.end)

		// Apply events
		if t.typ !in applied {
			applied << t.typ
			object.apply_event(t, t.time.start)
		}
	}
}

// Info
[inline]
pub fn (mut object GameObject) is_available_at(time f64) bool {
	// println("${time} | ${object.time}")
	return time >= object.time.start && time <= object.time.end
}