module microui

const style_max_color_stupid_workaround_const_bullshit = 14 // enums.color_max

pub const (
	default_style = Style{
		font: unsafe { nil }
		size: Vec2{68, 10}
		padding: 5
		spacing: 4
		indent: 24
		title_height: 24
		scrollbar_size: 12
		thumb_size: 8
		colors: [
			Color{230, 230, 230, 255}, // MU_COLOR_TEXT
			Color{25, 25, 25, 255}, // MU_COLOR_BORDER
			Color{50, 50, 50, 255}, // MU_COLOR_WINDOWBG
			Color{25, 25, 25, 255}, // MU_COLOR_TITLEBG
			Color{240, 240, 240, 255}, // MU_COLOR_TITLETEXT
			Color{0, 0, 0, 0}, // MU_COLOR_PANELBG
			Color{75, 75, 75, 255}, // MU_COLOR_BUTTON
			Color{95, 95, 95, 255}, // MU_COLOR_BUTTONHOVER
			Color{115, 115, 115, 255}, // MU_COLOR_BUTTONFOCUS
			Color{30, 30, 30, 255}, // MU_COLOR_BASE
			Color{35, 35, 35, 255}, // MU_COLOR_BASEHOVER
			Color{40, 40, 40, 255}, // MU_COLOR_BASEFOCUS
			Color{43, 43, 43, 255}, // MU_COLOR_SCROLLBASE
			Color{30, 30, 30, 255}, // MU_COLOR_SCROLLTHUMB
		]!
	}
)
