module texture

pub interface ITexture {
mut:
	id int
	width int
	height int
}

pub struct BaseTexture {
pub mut:
	id     int
	width  int
	height int
}
