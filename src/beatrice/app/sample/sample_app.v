module sample

import beatrice.app
import beatrice.engine
import beatrice.engine.renderer
import beatrice.drawable.sprite
import beatrice.engine.resource
import beatrice.util.math.vector

pub struct SampleApplication {
	app.Application
mut:
	manager &sprite.Manager        = unsafe { nil }
	atlas   &resource.TextureAtlas = unsafe { nil }

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
	sample_app.atlas = sample_app.engine.resources.create_atlas(1024, 1024)
	sample_app.manager = sprite.new_manager()
}

pub fn (mut sample_app SampleApplication) update() {
	sample_app.atlas.update()
	sample_app.manager.update(sample_app.engine.time.time)
}

pub fn (mut sample_app SampleApplication) draw(mut graphics renderer.IRenderer) {
	graphics.set_color(r: 25, g: 25, b: 25)

	sample_app.manager.draw(mut graphics)

	font := sample_app.engine.resources.get_font('Default')

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
	delta_t := sample_app.engine.time.delta
	sample_app.last_delta = (sample_app.last_delta * 0.9) + (delta_t * 0.1)
	fps := 1000.0 / sample_app.last_delta

	fps_string := '${int(fps)} fps'
	ms_string := '${sample_app.last_delta:.1f} ms'

	{
		mut font := sample_app.engine.resources.get_font('Default')
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
