module input

import beatrice.math.vector

pub struct Subcribable[T] {
pub mut:
	cb []T
}

pub fn (mut subscribe Subcribable[T]) trigger(state InputState, button ButtonType, pos vector.Vector2[f64]) {
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
	mouse    Subcribable[MouseCallback]
	keyboard Subcribable[KeyboardCallback]
}
