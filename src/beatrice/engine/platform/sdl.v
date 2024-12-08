module platform

import sdl
import beatrice.engine.renderer { OpenGLGraphic }

pub struct SDLEnviroment {
	Enviroment
pub mut:
	window &sdl.Window = unsafe { nil }
}

pub fn SDLEnviroment.create(window &sdl.Window) &SDLEnviroment {
	mut sdl_enviroment := &SDLEnviroment{
		window: unsafe { window }
	}

	return sdl_enviroment
}

pub fn (mut sdl_enviroment SDLEnviroment) create_renderer() &OpenGLGraphic {
	return OpenGLGraphic.create(sdl_enviroment.window)
}
