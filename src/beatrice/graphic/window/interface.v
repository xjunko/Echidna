module window

import gg

// TODO: :thinking:
// pub interface IContext {
// }

pub interface IWindow {
mut:
	args StartWindowArgument
	ctx &gg.Context // FNs
	init(voidptr)
	update(f64)
	draw(voidptr)
	start(StartWindowArgument)
}
