module main

import src.beatrice.graphic.window
import src.wakasagihime.kyukurarin
import src.wakasagihime.kaimen
import src.wakasagihime.osu

pub struct Window {
	window.CommonWindow
}

fn main() {
	$if demo_kyu_kurarin ? {
		kyukurarin.play()
		exit(1)
	} $else $if demo_ui ? {
		kaimen.play()
		exit(1)
	} $else $if demo_osu ? {
		osu.play()
	} $else {
		mut window := &Window{}

		window.start(
			width: 1280
			height: 720
		)
	}
}
