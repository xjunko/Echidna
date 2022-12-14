module sprite

import src.beatrice.component.object
import src.beatrice.math.vector
import src.beatrice.graphic.backend
import src.beatrice.graphic.texture

pub struct Sprite {
	object.GameObject
pub mut:
	textures []texture.ITexture
	origin   vector.Origin = vector.centre

	always_visible bool
}

pub fn (mut sprite Sprite) draw(arg backend.DrawConfig) {
	size := sprite.size
		.scale(arg.scale)

	pos := sprite.position
		.scale(arg.scale)
		.sub(sprite.origin.Vector2.multiply(size))
		.add(arg.offset)

	arg.backend.draw_image_with_config(
		texture: sprite.textures[0]
		position: pos
		size: size
		color: sprite.color
	)

	// Debug
	$if sprite_debug ? {
		// ???? what
		println('========')
		println('Drawing image with these attributes: ')
		println('Pos: ${pos.x} | ${pos.y}')
		println('Size: ${size.x} | ${size.y}')
		println('Color: ${sprite.color}')
		println('=============')

		arg.backend.draw_text(pos.x, pos.y, 'Sprite{ position: [${pos.x:.2}, ${pos.y:.2}] | always_visible: ${sprite.always_visible} | Textures: ${sprite.textures.len} }')
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
