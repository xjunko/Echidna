module window

pub type WindowFunctionCallback = fn (data voidptr)

fn empty_function(data voidptr) {
	println('StartWindowArgument: Default Callback!!!')
	println('Check your implementation!')
}

@[args; params]
pub struct StartWindowArgument {
pub:
	vsync  bool = true
	width  int
	height int

	// im not quite sure how to call parent init_fn so im just gonna
	// pass it thru the start argument and be done with it
	// ez
	init_fn  WindowFunctionCallback = empty_function
	frame_fn WindowFunctionCallback = empty_function
}
