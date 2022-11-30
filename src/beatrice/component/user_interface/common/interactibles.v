module common

import gg
import src.beatrice.graphic.sprite
import src.beatrice.math.vector
import src.beatrice.graphic.backend

pub type FNOnClick = fn (it IInteractible, typ MouseButton, pos vector.Vector2[f64])

pub interface IInteractible {
mut:
	id int
	on_click_cb []FNOnClick
	on_unclick_cb []FNOnClick
	init(mut ctx gg.Context)
	update(f64)
	on_click(typ MouseButton, pos vector.Vector2[f64])
	on_unclick(typ MouseButton, pos vector.Vector2[f64])
	draw(backend.DrawConfig)
}

// Common(s)
pub struct BaseInteractible {
	sprite.Sprite
mut:
	on_click_cb   []FNOnClick
	on_unclick_cb []FNOnClick
pub mut:
	id int // Useless
}

pub fn (mut interact BaseInteractible) init(mut ctx gg.Context) {}

// Events
pub fn (mut interact BaseInteractible) on_click(typ MouseButton, position vector.Vector2[f64]) {
	for mut cb in interact.on_click_cb {
		cb(interact, typ, position)
	}
}

pub fn (mut interact BaseInteractible) on_unclick(typ MouseButton, position vector.Vector2[f64]) {
	for mut cb in interact.on_unclick_cb {
		cb(interact, typ, position)
	}
}

// Add
pub fn (mut interact BaseInteractible) add_on_click_cb(func FNOnClick) {
	interact.on_click_cb << unsafe { func }
}

pub fn (mut interact BaseInteractible) add_on_unclick_cb(func FNOnClick) {
	interact.on_unclick_cb << unsafe { func }
}
