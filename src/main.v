module main

import src.beatrice.graphic.window

pub struct Window {
	window.CommonWindow
}

fn main() {
	mut window := &Window{}

	window.start(
		width: 1280
		height: 720
	)
}
