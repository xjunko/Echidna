module texture

// TODO: currently this is just a bootleg version of gg's `Image` struct
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
