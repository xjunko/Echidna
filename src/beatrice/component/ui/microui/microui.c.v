module microui

// i have no clue how to use c2v and chew
// fuck it, manual wrap it is then.
// this thing is not complete, only stuff that i used will be binded.
#flag -I @VMODROOT/microui
#include "microui.c"
#include "atlas.inl"

// types
pub type Font = voidptr
pub type ID = u32
pub type Vec2 = C.mu_Vec2
pub type Rect = C.mu_Rect
pub type Color = C.mu_Color

pub type BaseCommand = C.mu_BaseCommand
pub type TextCommand = C.mu_TextCommand
pub type RectCommand = C.mu_RectCommand
pub type IconCommand = C.mu_IconCommand
pub type ClipCommand = C.mu_ClipCommand
pub type Command = C.mu_Command

pub type Style = C.mu_Style
pub type Context = C.mu_Context
pub type Container = C.mu_Container

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
pub struct C.mu_BaseCommand {
pub mut:
	@type int
	size  int
}

[typedef]
pub struct C.mu_TextCommand {
pub mut:
	base  BaseCommand
	font  Font
	color Color
	str   &char
	pos   Vec2
}

[typedef]
pub struct C.mu_RectCommand {
pub mut:
	base  BaseCommand
	rect  Rect
	color Color
}

[typedef]
pub struct C.mu_IconCommand {
pub mut:
	base  BaseCommand
	id    int
	rect  Rect
	color Color
}

[typedef]
pub struct C.mu_ClipCommand {
pub mut:
	base BaseCommand
	rect Rect
}

[typedef]
pub struct C.mu_Command {
pub mut:
	@type int
	base  BaseCommand
	text  TextCommand
	rect  RectCommand
	icon  IconCommand
	clip  ClipCommand
}

// the boring stuff
[typedef]
pub struct C.mu_Style {
pub mut:
	font           Font
	size           Vec2
	padding        int
	spacing        int
	indent         int
	title_height   int
	scrollbar_size int
	thumb_size     int
	colors         [style_max_color_stupid_workaround_const_bullshit]Color
}

[typedef]
pub struct C.mu_Context {
pub mut:
	// callbacks
	text_width  fn (Font, &char, int) int
	text_height fn (Font) int
	// core states
	_style          Style
	style           &Style
	hover           ID
	focus           ID
	last_id         ID
	last_rect       Rect
	last_zindex     int
	updated_focus   int
	frame           int
	hover_root      Container
	next_hover_root Container
	scroll_target   Container
	number_edit_buf char
	number_edit     ID
	// stacks
	command_list    []Command
	root_list       []Container
	container_stack []Container
	clip_stack      []Rect
	id_stack        []ID
	// input state
	mouse_pos      Vec2
	last_mouse_pos Vec2
	mouse_delta    Vec2
	scroll_delta   Vec2
	mouse_down     int
	mouse_pressed  int
	key_down       int
	key_pressed    int
	input_text     [32]char
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
