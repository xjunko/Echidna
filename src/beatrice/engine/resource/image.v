module resource

pub interface Image {
mut:
	name string

	channels int
	width    int
	height   int

	has_alpha bool
	created   bool
}

pub struct ImageResource {
	Resource
pub mut:
	mipmapped   bool
	keep_in_mem bool

	format      int
	filter_mode int
	wrap_mode   int

	channels int
	width    int
	height   int

	has_alpha bool
	created   bool
}

pub fn ImageResource.create(path string, mipmap bool, keep_in_mem bool) &ImageResource {
	mut img := &ImageResource{
		Resource: Resource.create(path)
	}

	img.mipmapped = mipmap
	img.keep_in_mem = keep_in_mem

	img.channels = 4
	img.width = 1
	img.height = 1

	img.has_alpha = true

	return img
}
