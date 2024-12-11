module sprite

import beatrice.drawable.common
import beatrice.math.vector
import beatrice.engine.resource
import beatrice.engine.renderer

pub struct Sprite {
	common.Object2D
pub mut:
	textures      []&resource.Image
	origin        vector.Origin = vector.centre
	origin_offset vector.Vector2[f64]

	always_visible bool
	z_index        int
}

pub fn (mut sprite Sprite) draw(mut graphics renderer.IRenderer) {
	size := sprite.size.scale(1.5)

	pos := sprite.position
		.scale(1.5)
		.sub(sprite.origin.Vector2.multiply(size))
		.add(vector.Vector2[f64]{159.99999999999972, -2.8421709430404007e-13})

	graphics.draw_image(
		image:    sprite.textures[0]
		position: pos
		origin:   sprite.origin
		// origin_offset: sprite.origin_offset
		size:  size
		color: sprite.color
		// z_index:       sprite.z_index
		rotation: sprite.angle
		// effects:       sprite.effects
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
@[args; params]
pub struct ExtraResizeArgument {
pub mut:
	keep_ratio  bool
	keep_height bool // Resize till it fits on Target's Y
	resize_to   vector.Vector2[f64]
}

pub fn (mut sprite Sprite) reset_size_based_on_texture(extra ExtraResizeArgument) {
	mut ref_texture := unsafe { &sprite.textures[0] }
	texture_size := vector.Vector2[f64]{
		x: f64(ref_texture.width)
		y: f64(ref_texture.height)
	}

	if extra.resize_to.changed() {
		// Replace size as is.
		sprite.texture_size = extra.resize_to
		sprite.size = extra.resize_to

		// Replace size but keep ratio relative to texture's scale
		if extra.keep_ratio {
			mut ratio := extra.resize_to.x / texture_size.x

			// Make sure the height also fits.
			// Width will be over the target.
			if extra.keep_height {
				for (texture_size.y * ratio) < extra.resize_to.y {
					ratio += 0.1
				}
			}

			sprite.texture_size = texture_size.scale(ratio)
			sprite.size = texture_size.scale(ratio)
		}
	} else {
		// Default: Reset to sprite size
		sprite.texture_size.x = f64(ref_texture.width)
		sprite.texture_size.y = f64(ref_texture.height)

		sprite.size.x = sprite.texture_size.x
		sprite.size.y = sprite.texture_size.y
	}
}
