module engine

import beatrice.engine.font
import beatrice.engine.resource

pub struct ResourceManager {
mut:
	engine &Engine     = unsafe { nil }
	fonts  &font.Fonts = unsafe { nil }

	resources []&resource.Resource // TODO: Placeholder type
	images    map[string]&resource.Image
}

pub fn (mut manager ResourceManager) initialize() {
	manager.fonts = font.Fonts.create()
}

pub fn (mut manager ResourceManager) update() {
}

pub fn (mut manager ResourceManager) load_image(path string, name string) &resource.Image {
	if name.len > 0 {
		if in_cache := manager.images[name] {
			return in_cache
		}
	}

	mut img := manager.engine.graphics.create_image(path, true, true)
	manager.images[name] = img
	return img
}

pub fn (mut manager ResourceManager) load_image_no_name(path string) &resource.Image {
	if path.len > 0 {
		if in_cache := manager.images[path] {
			return in_cache
		}
	}

	mut img := manager.engine.graphics.create_image(path, true, true)
	manager.images[path] = img
	return img
}

// Font
pub fn (mut manager ResourceManager) get_font(name string) &font.Font {
	return manager.fonts.get_font(name)
}

pub fn ResourceManager.create(mut engine Engine) &ResourceManager {
	mut manager := &ResourceManager{
		engine: unsafe { engine }
	}

	manager.initialize()

	return manager
}
