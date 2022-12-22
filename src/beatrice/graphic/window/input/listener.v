module input

import src.beatrice.math.vector

pub type MouseCallback = fn (state MouseButtonState, button MouseButtonType, pos vector.Vector2[f64])

pub enum MouseButtonType {
	left
	middle
	right
}

pub enum MouseButtonState {
	click
	unclick
}

pub struct Subcribable[T] {
pub mut:
	cb []T
}

pub fn (mut subscribe Subcribable[T]) trigger(state MouseButtonState, button MouseButtonType, pos vector.Vector2[f64]) {
	println('${state}')

	for i := 0; i < subscribe.cb.len; i++ {
		func := unsafe { subscribe.cb[i] }
		func(state, button, pos)
	}
}

pub fn (mut subscribe Subcribable[T]) subscribe(cb T) {
	subscribe.cb << cb
}

pub struct InputListener {
pub mut:
	mouse Subcribable[MouseCallback]
}
