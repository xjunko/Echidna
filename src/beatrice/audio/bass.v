module audio

import libraries.bass

pub struct BASSBackend {
	BaseAudioBackend

	mut:
		has_init bool

	pub mut:
		typ AudioBackendType = .bass
}

pub fn (mut bass_backend BASSBackend) init() {
	bass.initialize_bass()
}

pub fn (mut bass_backend BASSBackend) load_audio(path string) IAudio {
	mut audio := &BassAudio{}

	// Make channel
	audio.channel = C.BASS_StreamCreateFile(0, path.str, 0, 0, C.BASS_STREAM_DECODE | C.BASS_STREAM_PRESCAN | C.BASS_ASYNCFILE)

	// FX
	audio.channel = C.BASS_FX_TempoCreate(audio.channel, C.BASS_FX_FREESOURCE|C.BASS_STREAM_DECODE)
	audio.bind_to_fx()

	return audio
}

// Track
pub struct BassAudio {
	BaseAudio // hopefully this name wont fuck me up later on in the future.

	mut:
		channel C.HSTREAM

	pub mut:
		id int = -1
}

pub fn (mut bass_audio BassAudio) bind_to_fx() {
	C.BASS_ChannelSetAttribute(bass_audio.channel, C.BASS_ATTRIB_TEMPO_OPTION_USE_QUICKALGO, 1)
	C.BASS_ChannelSetAttribute(bass_audio.channel, C.BASS_ATTRIB_TEMPO_OPTION_OVERLAP_MS, 4.0)
	C.BASS_ChannelSetAttribute(bass_audio.channel, C.BASS_ATTRIB_TEMPO_OPTION_SEQUENCE_MS, 30.0)
}

pub fn (mut bass_audio BassAudio) play() {
	C.BASS_Mixer_StreamAddChannel(bass.global.master, bass_audio.channel, C.BASS_MIXER_CHAN_NORAMPIN|C.BASS_MIXER_CHAN_BUFFER)
	bass_audio.playing = true
}