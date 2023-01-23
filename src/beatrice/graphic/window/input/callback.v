module input

import beatrice.math.vector

pub type MouseCallback = fn (state InputState, button ButtonType, pos vector.Vector2[f64])

pub type KeyboardCallback = fn (state InputState, button ButtonType, pos vector.Vector2[f64])
