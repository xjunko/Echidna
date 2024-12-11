module sample

import beatrice.app
import beatrice.engine
import beatrice.engine.renderer
import beatrice.util.math.vector
import beatrice.drawable.sprite

pub struct SampleApplication {
	app.Application
mut:
	manager &sprite.Manager = unsafe { nil }
	spr     &sprite.Sprite  = unsafe { nil }

	last_delta f64
}

pub fn SampleApplication.create(mut c_engine engine.Engine) &SampleApplication {
	mut application := &SampleApplication{
		Application: app.Application.create(mut c_engine)
	}

	application.initialize()

	return application
}

pub fn (mut sample_app SampleApplication) initialize() {
	sample_app.manager = sprite.new_manager()

	sample_app.spr = &sprite.Sprite{
		textures:       [
			sample_app.c_engine.resource_manager.load_image('assets/images/teto.png',
				'teto'),
		]
		always_visible: true
	}

	sample_app.spr.position.x = 640
	sample_app.spr.position.y = 360

	sample_app.spr.reset_size_based_on_texture()
	sample_app.spr.reset_attributes_based_on_transforms()

	sample_app.manager.add(mut sample_app.spr)
}

pub fn (mut sample_app SampleApplication) update() {
	sample_app.manager.update(sample_app.c_engine.time.time)
}

pub fn (mut sample_app SampleApplication) draw(mut graphics renderer.IRenderer) {
	graphics.set_color(r: 25, g: 25, b: 25)

	// Rotating rect
	// TODO

	font := sample_app.c_engine.resource_manager.get_font('Default')

	graphics.draw_text(font,
		text:     'Title'
		color:    renderer.Color.from_rgb[u8](255, 255, 255)
		size:     vector.Vector2[f64]{80, 80}
		position: vector.Vector2[f64]{70, 240 - 24}
	)

	graphics.draw_text(font,
		text:     'New Game'
		color:    renderer.Color.from_rgb[u8](255, 255, 255)
		size:     vector.Vector2[f64]{24, 24}
		position: vector.Vector2[f64]{70 + 10, 240 + 64 + 32}
	)

	graphics.draw_text(font,
		text:     'Load Game'
		color:    renderer.Color.from_rgb[u8](255, 255, 255)
		size:     vector.Vector2[f64]{24, 24}
		position: vector.Vector2[f64]{70 + 10, 240 + 64 + 32 + 24}
	)

	graphics.draw_text(font,
		text:     'Options'
		color:    renderer.Color.from_rgb[u8](255, 255, 255)
		size:     vector.Vector2[f64]{24, 24}
		position: vector.Vector2[f64]{70 + 10, 240 + 64 + 32 + 24 + 24}
	)

	graphics.draw_text(font,
		text:     'Exit'
		color:    renderer.Color.from_rgb[u8](255, 255, 255)
		size:     vector.Vector2[f64]{24, 24}
		position: vector.Vector2[f64]{70 + 10, 240 + 64 + 32 + 24 + 24 + 24}
	)

	sample_app.draw_fps(mut graphics)
}

pub fn (mut sample_app SampleApplication) draw_fps(mut graphics renderer.IRenderer) {
	delta_t := sample_app.c_engine.time.delta
	sample_app.last_delta = (sample_app.last_delta * 0.9) + (delta_t * 0.1)
	fps := 1000.0 / sample_app.last_delta

	fps_string := '${int(fps)} fps'
	ms_string := '${sample_app.last_delta:.1f} ms'

	{
		mut font := sample_app.c_engine.resource_manager.get_font('Default')
		mut color := renderer.Color.from_rgb[u8](255, 255, 255)

		if fps < 120 {
			color.b = 0
			color.g = 0
		}

		graphics.draw_text(font,
			text:           fps_string
			color:          color
			align:          .right
			vertical_align: .bottom
			size:           vector.Vector2[f64]{24, 24}
			position:       vector.Vector2[f64]{1280, 720 - 24}
			outline:        true
		)

		graphics.draw_text(font,
			text:           ms_string
			color:          color
			align:          .right
			vertical_align: .bottom
			size:           vector.Vector2[f64]{24, 24}
			position:       vector.Vector2[f64]{1280, 720}
			outline:        true
		)
	}
}
