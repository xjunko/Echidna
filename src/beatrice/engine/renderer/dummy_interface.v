module renderer

pub interface IRenderer {
mut:
	initialize()

	begin()
	end()

	set_bg_color(u8, u8, u8)
	set_color(u8, u8, u8)
}
