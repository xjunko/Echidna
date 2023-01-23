module audio

import beatrice.audio.libraries.miniaudio

// Backend
[heap]
pub struct MABackend {
	BaseAudioBackend
mut:
	m_volume f64
pub mut:
	// vfmt off
	device &miniaudio.Device = unsafe { nil }
	audio  []&MAAudio
	// vfmt on
}

pub fn (mut ma_backend MABackend) init() {
	mut config := miniaudio.device_config_init(.playback)

	config.playback.format = .f32
	config.playback.channels = 2
	config.sampleRate = 44100
	config.dataCallback = voidptr(ma_backend.i_data_callback)
	config.pUserData = ma_backend

	ma_backend.device = &miniaudio.Device{}

	if miniaudio.device_init(miniaudio.null, &config, ma_backend.device) != .success {
		panic('[Audio] Failed to create MiniAudio backend!')

		return
	} else {
		println('[Audio] MiniAudio started!')
	}

	ma_backend.i_start_miniaudio()
}

pub fn (mut ma_backend MABackend) i_start_miniaudio() {
	if miniaudio.device_start(ma_backend.device) != .success {
		miniaudio.device_uninit(ma_backend.device)
		panic('[Audio] Failed to start MiniAudio backend!')
	}
}

pub fn (mut ma_backend MABackend) i_data_callback(_ voidptr, p_output voidptr, p_input voidptr, frame_count u32) {
	for audio in ma_backend.audio {
		if !audio.playing {
			continue
		}

		miniaudio.decoder_read_pcm_frames(audio.decoder, p_output, frame_count, miniaudio.null)
	}
}

pub fn (mut ma_backend MABackend) load_audio(path string) IAudio {
	mut decoder_config := miniaudio.decoder_config_init(.f32, 2, 44100)
	mut decoder := miniaudio.Decoder{}

	miniaudio.decoder_init_file(path.str, &decoder_config, &decoder)

	mut audio := &MAAudio{
		decoder: &decoder
	}

	ma_backend.audio << audio

	return audio
}

pub fn (mut ma_backend MABackend) set_volume(v f64) {
	ma_backend.m_volume = v

	miniaudio.device_set_master_volume(ma_backend.device, f32(v))
}

// Audio
pub struct MAAudio {
	BaseAudio
pub mut:
	// vfmt off
	decoder &miniaudio.Decoder
	volume  f32
	// vfmt on
}

pub fn (mut ma_audio MAAudio) play() {
	ma_audio.playing = true
}
