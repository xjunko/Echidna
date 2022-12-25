module microui

// i have no clue how to use c2v and chew
// fuck it, manual wrap it is then.
// this thing is not complete, only stuff that i used will be binded.
#flag -I @VMODROOT/microui
#include "microui.c"
#include "atlas.inl"

// types
pub type Font = voidptr

// commons
[typedef]
pub struct C.mu_Vec2 {
pub mut:
	x int
	y int
}

[typedef]
pub struct C.mu_Rect {
pub mut:
	x int
	y int
	w int
	h int
}

[typedef]
pub struct C.mu_Color {
pub mut:
	r u8
	g u8
	b u8
	a u8
}

// commands
[typedef]
pub struct C.mu_TextCommand {
pub mut:
	str &char
	pos C.mu_Vec2
}

[typedef]
pub struct C.mu_RectCommand {
pub mut:
	rect  C.mu_Rect
	color C.mu_Color
}

[typedef]
pub struct C.mu_IconCommand {
pub mut:
	id    int
	rect  C.mu_Rect
	color C.mu_Color
}

[typedef]
pub struct C.mu_ClipCommand {
pub mut:
	rect C.mu_Rect
}

[typedef]
pub struct C.mu_Command {
pub mut:
	@type int
	text  C.mu_TextCommand
	rect  C.mu_RectCommand
	icon  C.mu_IconCommand
	clip  C.mu_ClipCommand
}

// the boring stuff
[typedef]
pub struct C.mu_Context {
pub mut:
	// callbacks
	text_width  fn (Font, &char, int) int
	text_height fn (Font) int
	// microui's assert will fail without this.
	frame int
}

[typedef]
pub struct C.mu_Container {
pub mut:
	open   int
	zindex int
}

// functions
pub fn C.mu_init(ctx &C.mu_Context)
pub fn C.mu_begin(ctx &C.mu_Context)
pub fn C.mu_end(ctx &C.mu_Context)

pub fn C.mu_get_current_container(&C.mu_Context) &&C.mu_Container

pub fn C.mu_begin_window(&C.mu_Context, &u8, C.mu_Rect) bool
pub fn C.mu_end_window(&C.mu_Context)

pub fn C.mu_text(&C.mu_Context, &u8)
pub fn C.mu_label(&C.mu_Context, &u8)
pub fn C.mu_button(&C.mu_Context, &u8) bool
pub fn C.mu_header(&C.mu_Context, &u8) bool
pub fn C.mu_header_ex(&C.mu_Context, &u8, int) bool
pub fn C.mu_layout_row(&C.mu_Context, int, &int, &int)

pub fn C.mu_open_popup(&C.mu_Context, &u8)
pub fn C.mu_begin_popup(&C.mu_Context, &u8) bool
pub fn C.mu_end_popup(&C.mu_Context)

pub fn C.mu_begin_panel(&C.mu_Context, &u8)
pub fn C.mu_end_panel(&C.mu_Context)

pub fn C.mu_next_command(&C.mu_Context, &&C.mu_Command) bool

// Input(s)
// [Mouse]
pub fn C.mu_input_mousemove(&C.mu_Context, int, int)
pub fn C.mu_input_mousedown(&C.mu_Context, int, int, int)
pub fn C.mu_input_mouseup(&C.mu_Context, int, int, int)
pub fn C.mu_input_scroll(&C.mu_Context, int, int)
