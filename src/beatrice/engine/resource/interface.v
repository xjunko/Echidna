module resource

pub interface IResourceManager {
mut:
	load_image(path string, name string) &Image
}

pub interface Image {
mut:
	name string

	channels int
	width    int
	height   int

	has_alpha bool
	created   bool
}
