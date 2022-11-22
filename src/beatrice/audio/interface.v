module audio

pub enum AudioBackendType {
	unspecified
	bass
	miniaudio // TODO
}

pub interface IAudioBackend {
	mut:
		typ	AudioBackendType

	init()
	load_audio(string) IAudio
}

pub interface IAudio {
	mut:
		id int // This does nothing
		playing bool

	play() 
	stop()
}

// Base Struct
pub struct BaseAudioBackend {
	pub mut:
		typ AudioBackendType = .unspecified
}

pub fn (mut base_backend BaseAudioBackend) init() {}
pub fn (mut base_backend BaseAudioBackend) load_audio(path string) IAudio { return &BaseAudio{} }

pub struct BaseAudio {
	pub mut:
		id int = -1
		playing bool
}

pub fn (mut base_audio BaseAudio) play() {}
pub fn (mut base_audio BaseAudio) stop() {}