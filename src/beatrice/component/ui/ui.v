module ui

import gx
import sokol.sgl

import src.beatrice.component.object
import src.beatrice.component.ui.microui
import src.beatrice.component.ui.microui.enums
import src.beatrice.graphic.backend

//
[heap]
pub struct UIManager {
pub mut:
	backend backend.IBackend
	ctx     C.mu_Context
}

pub fn (mut ui UIManager) init() {
	ui.ctx = unsafe { &C.mu_Context(C.malloc(sizeof(C.mu_Context))) } // amazing
	C.mu_init(&ui.ctx)

	ui.ctx._style = microui.default_style
	ui.ctx.style = &ui.ctx._style

	ui.ctx.text_width = ui.text_width
	ui.ctx.text_height = ui.text_height
}

pub fn (mut ui UIManager) begin() {
	C.mu_begin(&ui.ctx)
}

pub fn (mut ui UIManager) end() {
	C.mu_end(&ui.ctx)
}

pub fn (mut ui UIManager) text_width(_ microui.Font, str &char, len int) int {
	return ui.backend.text_width(unsafe { cstring_to_vstring(str) })
}

pub fn (mut ui UIManager) text_height(_ microui.Font) int {
	return ui.backend.text_height('joe mama')
}

pub fn (mut ui UIManager) draw() {
	cmd := &microui.Command(unsafe { nil })

	for C.mu_next_command(&ui.ctx, &cmd) {
		match cmd.@type {
			enums.command_text {
				ui.backend.draw_text(f64(cmd.text.pos.x), f64(cmd.text.pos.y), unsafe { cstring_to_vstring(cmd.text.str) },
					gx.TextCfg{
					color: gx.Color{cmd.text.color.r, cmd.text.color.g, cmd.text.color.b, cmd.text.color.a}
				})
			}
			enums.command_rect {
				ui.backend.draw_rect_filled(f64(cmd.rect.rect.x), f64(cmd.rect.rect.y),
					f64(cmd.rect.rect.w), f64(cmd.rect.rect.h), object.GameObjectColor[f64]{f64(cmd.rect.color.r), f64(cmd.rect.color.g), f64(cmd.rect.color.b), f64(cmd.rect.color.a)})
			}
			enums.command_icon {
				// FIXME: fix this
				x := cmd.rect.rect.x + (cmd.rect.rect.w - 16) / 2
				y := cmd.rect.rect.y + (cmd.rect.rect.h - 16) / 2

				ui.backend.draw_rect_filled(f64(x), f64(y), f64(16), f64(16), object.GameObjectColor[f64]{f64(cmd.icon.color.r), f64(cmd.icon.color.g), f64(cmd.icon.color.b), f64(cmd.icon.color.a)})
			}
			enums.command_clip {
				// This only works with gg-backend
				sgl.scissor_rect(cmd.clip.rect.x, cmd.clip.rect.y, cmd.clip.rect.w, cmd.clip.rect.h,
					true)
			}
			else {}
		}
	}
}

pub fn (mut ui UIManager) demo_ui() {
	rect := C.mu_Rect{40, 40, 300, 450}

	if C.mu_begin_window(&ui.ctx, "Echidna's UI".str, rect) {
		if C.mu_header_ex(&ui.ctx, 'Info'.str, C.MU_OPT_EXPANDED) {
			C.mu_layout_row(&ui.ctx, 2, [85, -1].data, 16)
			C.mu_label(&ui.ctx, 'Message:'.str)
			C.mu_label(&ui.ctx, 'Hello world!!'.str)
		}

		C.mu_end_window(&ui.ctx)
	}
}
