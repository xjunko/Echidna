module audio

pub enum AudioBackendType {
	unspecified
	bass
	miniaudio // TODO
}

pub interface IAudioBackend {
mut:
	typ AudioBackendType
	init()
	load_audio(string) IAudio
	load_sample(string) ISample
	set_volume(f64)
}

pub interface IAudio {
mut:
	id int // This does nothing
	playing bool
	play()
	pause()
	resume()
	set_volume(f64)
}

// It's like `IAudio` but spam-able.
pub interface ISample {
mut:
	id int // This does nothing
	playing bool
	play()
	pause()
	resume()
	set_volume(f64)
}

// Base Struct
pub struct BaseAudioBackend {
pub mut:
	typ AudioBackendType = .unspecified
}

pub fn (mut base_backend BaseAudioBackend) init() {}

pub fn (mut base_backend BaseAudioBackend) load_audio(path string) IAudio {
	return &BaseAudio{}
}

pub fn (mut base_backend BaseAudioBackend) load_sample(path string) ISample {
	return &BaseAudio{}
}

pub fn (mut base_backend BaseAudioBackend) set_volume(vol f64) {}

pub struct BaseAudio {
pub mut:
	id      int = -1
	playing bool
}

pub fn (mut base_audio BaseAudio) play() {}

pub fn (mut base_audio BaseAudio) pause() {}

pub fn (mut base_audio BaseAudio) resume() {}

pub fn (mut base_audio BaseAudio) set_volume(vol f64) {}
