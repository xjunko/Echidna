module engine

import bass

pub struct Track {
	bass.Track
}

pub struct SoundManager {
pub mut:
	tracks map[string]&Track
}

pub fn (mut sound_manager SoundManager) initialize() {
	bass.start()
}

pub fn (mut sound_manager SoundManager) load_track(name string, path string) &Track {
	if name !in sound_manager.tracks {
		sound_manager.tracks[name] = &Track{bass.new_track(path)}
	}

	return unsafe { sound_manager.tracks[name] }
}

pub fn SoundManager.create() &SoundManager {
	mut sound_manager := &SoundManager{}

	sound_manager.initialize()

	return sound_manager
}
