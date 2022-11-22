module sprite

import gg

import beatrice.component.object

import beatrice.math.vector


// TODO: currently this is just a bootleg version of gg's `Image` struct
pub interface ITexture {
	mut:
		id int
		width int
		height int
}

pub struct Sprite {
	object.GameObject

	pub mut:
		textures []ITexture
		origin   vector.Origin
}

pub fn (mut sprite Sprite) draw(ctx &gg.Context) {
	mut texture := unsafe { &sprite.textures[0] }

	if mut texture is gg.Image {
		size := sprite.size
			.scale(1.500000000000001)

		pos := sprite.position
			.scale(1.500000000000001)
			.sub(sprite.origin.Vector2.multiply(size))
			.add(vector.Vector2<f64>{159.99999999999972, -2.8421709430404007e-13})

		ctx.draw_image_with_config(gg.DrawImageConfig{
			img: texture,
			img_id: texture.id,
			img_rect: gg.Rect{
				x: f32(pos.x),
				y: f32(pos.y),
				width: f32(size.x),
				height: f32(size.y)
			},
			color: gg.Color{255, 255, 255, u8(sprite.color.a)}
		})
	}
	
}

// Sprite specific reset
pub fn (mut sprite Sprite) reset_size_based_on_texture() {
	mut texture := unsafe { &sprite.textures[0] }

	sprite.texture_size.x = f64(texture.width)
	sprite.texture_size.y = f64(texture.height)

	sprite.size.x = sprite.texture_size.x
	sprite.size.y = sprite.texture_size.y
}