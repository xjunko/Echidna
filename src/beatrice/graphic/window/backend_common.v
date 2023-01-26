module window

pub type WindowFunctionCallback = fn (data voidptr)

[args; params]
pub struct StartWindowArgument {
pub:
	vsync  bool = true
	width  int
	height int
	// im not quite sure how to call parent init_fn so im just gonna
	// pass it thru the start argument and be done with it
	// ez
	init_fn  WindowFunctionCallback
	frame_fn WindowFunctionCallback
}
