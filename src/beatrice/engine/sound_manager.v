module engine

import bass

pub struct SoundManager {
pub mut:
	tracks map[string]&bass.Track
}

pub fn (mut sound_manager SoundManager) initialize() {
	bass.start()
}

pub fn SoundManager.create() &SoundManager {
	mut sound_manager := &SoundManager{}

	sound_manager.initialize()

	return sound_manager
}
