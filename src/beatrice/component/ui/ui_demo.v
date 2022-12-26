module ui

import src.beatrice.component.ui.microui
import src.beatrice.component.ui.microui.enums

pub fn (mut ui UIManager) demo_ui() {
	ui.ctx.style.size.x = 75
	ui.ctx.style.size.y = 30
	ui.ctx.style.spacing = 25

	ui.ctx.style.colors[enums.color_border].a = 0
	ui.ctx.style.colors[enums.color_windowbg].a = 0
	ui.ctx.style.colors[enums.color_titlebg].a = 0

	// ui.ctx.style.colors[enums.color_panelbg].a = 0
	// ui.ctx.style.colors[enums.color_base].a = 0

	rect := microui.Rect{70, 350, 300, 450}

	if C.mu_begin_window(&ui.ctx, ''.str, rect) {
		if C.mu_button(&ui.ctx, 'New Game'.str) {
			println('NG')
		}

		if C.mu_button(&ui.ctx, 'Continue'.str) {
			println('C')
		}

		if C.mu_button(&ui.ctx, 'Options'.str) {
			println('O')
		}

		if C.mu_button(&ui.ctx, 'Exit'.str) {
			println('E')
		}

		C.mu_end_window(&ui.ctx)
	}
}
