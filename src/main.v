module main

import src.beatrice.graphic.window
import src.wakasagihime.kyukurarin

pub struct Window {
	window.CommonWindow
}

fn main() {
	$if demo_kyu_kurarin ? {
		kyukurarin.play()
		exit(1)
	} $else {
		mut window := &Window{}

		window.start(
			width: 1280
			height: 720
		)
	}
}
