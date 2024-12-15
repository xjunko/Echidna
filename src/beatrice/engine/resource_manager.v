module engine

import beatrice.engine.font
import beatrice.engine.resource

pub struct ResourceManager {
mut:
	engine &Engine     = unsafe { nil }
	fonts  &font.Fonts = unsafe { nil }

	atlas  map[string]&resource.TextureAtlas
	images map[string]&resource.Image
}

pub fn (mut manager ResourceManager) initialize() {
	manager.fonts = font.Fonts.create()
}

pub fn (mut manager ResourceManager) update() {
}

// Regular image loading
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

// Atlas
pub fn (mut manager ResourceManager) create_atlas(width int, height int) &resource.TextureAtlas {
	mut atlas := resource.TextureAtlas.create(width, height)
	atlas.name = 'ATLAS_${width}x${height}'

	manager.atlas[atlas.name] = atlas
	return atlas
}

pub fn (mut manager ResourceManager) load_image_to_atlas(path string, mut atlas resource.TextureAtlas) &resource.Image {
	if path.len > 0 {
		if in_cache := manager.images[path] {
			return in_cache
		}
	}

	mut entry := atlas.add_texture_from_file(path)
	mut img := manager.engine.graphics.create_image_from_atlas(entry, &atlas)
	manager.images[path] = img
	return img
}

pub fn (mut manager ResourceManager) load_image_from_atlas(entry &resource.AtlasEntry, atlas &resource.TextureAtlas) &resource.Image {
	if entry.name.len > 0 {
		if in_cache := manager.images[entry.name] {
			return in_cache
		}
	}

	mut img := manager.engine.graphics.create_image_from_atlas(entry, atlas)
	manager.images[entry.name] = img
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
