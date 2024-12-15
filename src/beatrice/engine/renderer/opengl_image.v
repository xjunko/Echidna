module renderer

import stbi
import thirdparty.sokol.gfx
import beatrice.util.math.vector
import beatrice.engine.resource

pub struct OpenGLImage {
	resource.ImageResource
mut:
	s_image gfx.Image

	buffer &u8 = unsafe { nil }

	u [2]f32 = [f32(0.0), 1.0]!
	v [2]f32 = [f32(0.0), 1.0]!
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

pub fn OpenGLImage.create_from_size(size vector.Vector2[int], mipmapped bool, keep_in_mem bool) &OpenGLImage {
	mut img := &OpenGLImage{}

	img.width = size.x
	img.height = size.y
	img.channels = 4

	sz := size.x * size.y * 4
	img.buffer = unsafe { malloc(sz) }

	mut img_desc := gfx.ImageDesc{
		width:  img.width
		height: img.height
		label:  &u8(0)
	}

	img_desc.data.subimage[0][0] = gfx.Range{
		ptr:  img.buffer
		size: usize(sz)
	}

	img.s_image = gfx.make_image(&img_desc)
	img.created = true

	return img
}

pub fn OpenGLImage.create_from_atlas(entry &resource.AtlasEntry, atlas &resource.TextureAtlas) &OpenGLImage {
	mut img := &OpenGLImage{}

	img.width = entry.width
	img.height = entry.height
	img.channels = 4

	img.u[0] = f32(entry.x_offset) / f32(atlas.width)
	img.v[0] = f32(entry.y_offset) / f32(atlas.height)

	img.u[1] = f32(entry.x_offset + entry.width) / f32(atlas.width)
	img.v[1] = f32(entry.y_offset + entry.height) / f32(atlas.height)

	img.s_image = &atlas.atlas
	img.created = true

	stbi.stbi_write_jpg(entry.name + '.jpg', atlas.width, atlas.height, 4, atlas.data.data,
		100) or { panic(err) }

	return img
}
