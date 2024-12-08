module input

type Keycode = u32

pub struct KeyboardEvent {
mut:
	keycode  Keycode
	consumed bool
}

pub fn KeyboardEvent.create(keycode Keycode) &KeyboardEvent {
	return &KeyboardEvent{
		keycode:  keycode
		consumed: false
	}
}

pub fn (mut keyboard_event KeyboardEvent) consume() {
	keyboard_event.consumed = true
}

pub fn (keyboard_event KeyboardEvent) is_consumed() bool {
	return keyboard_event.consumed
}
