module ui

import gx
import src.beatrice.component.object
import src.beatrice.component.ui.microui
import src.beatrice.graphic.backend
import sokol.sgl

//
// HACK: refer to UIManager's draw
[typedef]
pub struct C.mu_Command {
pub mut:
	@type int
	text  C.mu_TextCommand
	rect  C.mu_RectCommand
	icon  C.mu_IconCommand
	clip  C.mu_ClipCommand
}

//

[heap]
pub struct UIManager {
pub mut:
	backend backend.IBackend
	ctx     C.mu_Context
}

pub fn (mut ui UIManager) text_width(_ microui.Font, str &char, len int) int {
	mut l_backend := unsafe { &ui.backend }

	if mut l_backend is backend.GGBackend {
		return l_backend.ctx.text_width(unsafe { cstring_to_vstring(str) })
	}

	return 1 // TODO: handle this
}

pub fn (mut ui UIManager) text_height(_ microui.Font) int {
	mut l_backend := unsafe { &ui.backend }

	if mut l_backend is backend.GGBackend {
		return l_backend.ctx.text_height('joe mama')
	}

	return 1 // TODO: handle this
}

pub fn (mut ui UIManager) init() {
	ui.ctx = unsafe { &C.mu_Context(C.malloc(sizeof(C.mu_Context))) } // amazing
	C.mu_init(&ui.ctx)

	ui.ctx.text_width = ui.text_width
	ui.ctx.text_height = ui.text_height
}

pub fn (mut ui UIManager) begin() {
	C.mu_begin(&ui.ctx)
}

pub fn (mut ui UIManager) end() {
	C.mu_end(&ui.ctx)
}

pub fn (mut ui UIManager) draw() {
	// for whatever reason this is invalid if i didnt
	// redeclare the thing... weird
	cmd := &C.mu_Command(unsafe { nil })

	for C.mu_next_command(&ui.ctx, &cmd) {
		match cmd.@type {
			C.MU_COMMAND_TEXT {
				ui.backend.draw_text(f64(cmd.text.pos.x), f64(cmd.text.pos.y), unsafe { cstring_to_vstring(cmd.text.str) },
					gx.TextCfg{
					color: gx.white
				})
			}
			C.MU_COMMAND_RECT {
				ui.backend.draw_rect_filled(f64(cmd.rect.rect.x), f64(cmd.rect.rect.y),
					f64(cmd.rect.rect.w), f64(cmd.rect.rect.h), object.GameObjectColor[f64]{f64(cmd.rect.color.r), f64(cmd.rect.color.g), f64(cmd.rect.color.b), f64(cmd.rect.color.a)})
			}
			C.MU_COMMAND_ICON {
				// FIXME: fix this
				x := cmd.rect.rect.x + (cmd.rect.rect.w - 16) / 2
				y := cmd.rect.rect.y + (cmd.rect.rect.h - 16) / 2

				ui.backend.draw_rect_filled(f64(x), f64(y), f64(16), f64(16), object.GameObjectColor[f64]{f64(cmd.icon.color.r), f64(cmd.icon.color.g), f64(cmd.icon.color.b), f64(cmd.icon.color.a)})
			}
			C.MU_COMMAND_CLIP {
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
