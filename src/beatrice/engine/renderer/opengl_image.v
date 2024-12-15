module renderer

import stbi
import thirdparty.sokol.gfx
import beatrice.engine.resource

pub struct OpenGLImage {
	resource.ImageResource
mut:
	s_image gfx.Image
pub mut:
	stb_img stbi.Image
}

pub fn OpenGLImage.create(path string, mipmapped bool, keep_in_mem bool) &OpenGLImage {
	mut img := &OpenGLImage{
		ImageResource: resource.ImageResource.create(path, mipmapped, keep_in_mem)
	}

	img.stb_img = stbi.load(path) or { panic(err) }

	img.width = img.stb_img.width
	img.height = img.stb_img.height
	img.channels = img.stb_img.nr_channels

	mut img_desc := gfx.ImageDesc{
		width:  img.width
		height: img.height
		label:  path.str
	}

	img_desc.data.subimage[0][0] = gfx.Range{
		ptr:  img.stb_img.data
		size: usize(4 * img.width * img.height)
	}

	img.s_image = gfx.make_image(&img_desc)

	img.created = true

	return img
}
