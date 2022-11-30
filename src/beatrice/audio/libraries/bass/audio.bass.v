module bass

pub const (
	global         = &GlobalMixer{}
	todo_offscreen = false // TODO: Make this configurable
)

pub struct GlobalMixer {
pub mut:
	master C.HSTREAM
}

// initialize_bass sets up the `BASS` stuff
// note that this function is "fine-tuned" for rhythm game and
// you might not want that.
pub fn initialize_bass() {
	playback_buffer_length := int(100)
	device_buffer_length := int(10)
	update_period := int(5)
	dev_update_period := int(10)

	C.BASS_SetConfig(C.BASS_CONFIG_DEV_NONSTOP, 1)
	C.BASS_SetConfig(C.BASS_CONFIG_VISTA_TRUEPOS, 0)
	C.BASS_SetConfig(C.BASS_CONFIG_BUFFER, playback_buffer_length)
	C.BASS_SetConfig(C.BASS_CONFIG_UPDATEPERIOD, update_period)
	C.BASS_SetConfig(C.BASS_CONFIG_DEV_BUFFER, device_buffer_length)
	C.BASS_SetConfig(C.BASS_CONFIG_DEV_PERIOD, dev_update_period)
	C.BASS_SetConfig(68, 1)

	mut device_id := int(-1)
	mut mixer_flags := C.BASS_MIXER_NONSTOP

	// Offscreen
	if bass.todo_offscreen {
		println('[Audio] Passing offscreen flags for BASS!')

		device_id = int(0)
		mixer_flags |= C.BASS_SAMPLE_FLOAT | C.BASS_STREAM_DECODE
	}

	// Init
	if C.BASS_Init(device_id, 48000, 0, 0, 0) != 0 {
		println('[Audio] BASS started!')

		// Mixers
		master_mixer := C.BASS_Mixer_StreamCreate(48000, 2, mixer_flags)

		C.BASS_ChannelSetAttribute(master_mixer, C.BASS_ATTRIB_BUFFER, 0)
		C.BASS_ChannelSetDevice(master_mixer, C.BASS_GetDevice())
		C.BASS_ChannelPlay(master_mixer, 0)

		// Point global to that mixer
		// this is cursed
		unsafe {
			mut g_mixer := bass.global
			g_mixer.master = master_mixer
		}
	} else {
		println('[Audio] Failed to start BASS!')
	}
}
