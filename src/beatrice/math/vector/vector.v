module vector

import math

pub struct Vector2<T> {
	pub mut:
		x T
		y T
}

pub fn (v Vector2<T>) str() string {
	return "Vector<${typeof(v.x).name}>{${v.x}, ${v.y}}"
}

pub fn (v Vector2<T>) add(v1 Vector2<T>) Vector2<T> {
	return Vector2<T>{
		v.x + v1.x,
		v.y + v1.y
	}
}

pub fn (v Vector2<T>) sub(v1 Vector2<T>) Vector2<T> {
	return Vector2<T>{
		v.x - v1.x,
		v.y - v1.y
	}
}

pub fn (v Vector2<T>) multiply(v1 Vector2<T>) Vector2<T> {
	return Vector2<T>{
		v.x * v1.x,
		v.y * v1.y,
	}
}

pub fn (v Vector2<T>) middle(v1 Vector2<T>) Vector2<T> {
	return Vector2<T>{
		(v.x + v1.x) / 2,
		(v.y + v1.y) / 2
	}
}

pub fn (v Vector2<T>) distance(v1 Vector2<T>) f64 {
	return math.sqrt(
		math.pow(v1.x - v.x, 2) +
		math.pow(v1.y - v.y, 2)
	)
}


pub fn (v Vector2<T>) scale(by T) Vector2<T> {
	return Vector2<T>{
		v.x * by,
		v.y * by
	}
}


pub fn (v Vector2<T>) equal(t Vector2<T>) bool {
	return (v.x == t.x) && (v.y == t.y)
}

pub fn (v Vector2<T>) clone() Vector2<T> {
	return Vector2<T>{...v}
}