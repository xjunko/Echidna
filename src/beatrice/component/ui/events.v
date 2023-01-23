module ui

import beatrice.graphic.window.input
import beatrice.math.vector

// this part sucks so im just gonna split it into its own file
pub fn (mut ui UIManager) on_click(button input.ButtonType, pos vector.Vector2[f64]) {
	// println('Click: ${button} | ${pos} | ${int(button)}')
	C.mu_input_mousedown(&ui.ctx, int(pos.x), int(pos.y), int(button))
}

pub fn (mut ui UIManager) on_unclick(button input.ButtonType, pos vector.Vector2[f64]) {
	C.mu_input_mouseup(&ui.ctx, int(pos.x), int(pos.y), int(button))
}

pub fn (mut ui UIManager) on_move(pos vector.Vector2[f64]) {
	C.mu_input_mousemove(&ui.ctx, int(pos.x), int(pos.y))
}
