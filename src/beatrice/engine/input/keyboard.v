module input

pub interface KeyboardConsumer {
mut:
	on_key_down(ev &KeyboardEvent)
	on_key_up(ev &KeyboardEvent)
}

pub struct Keyboard {
	InputDevice
pub mut:
	control_down bool
	alt_down     bool
	shift_down   bool
	super_down   bool

	listeners []&KeyboardConsumer
}

pub fn Keyboard.create() &Keyboard {
	return &Keyboard{
		control_down: false
		alt_down:     false
		shift_down:   false
		super_down:   false
		listeners:    []
	}
}

pub fn (mut keyboard Keyboard) add_listener(listener &KeyboardConsumer) {
	keyboard.listeners << listener
}

pub fn (mut keyboard Keyboard) on_key_down(keycode Keycode) {
	mut ev := KeyboardEvent.create(keycode)

	for i := 0; i < keyboard.listeners.len; i++ {
		keyboard.listeners[i].on_key_down(ev)

		if ev.is_consumed() {
			break
		}
	}
}

pub fn (mut keyboard Keyboard) on_key_up(keycode Keycode) {
	mut ev := KeyboardEvent.create(keycode)

	for i := 0; i < keyboard.listeners.len; i++ {
		keyboard.listeners[i].on_key_up(ev)

		if ev.is_consumed() {
			break
		}
	}
}
