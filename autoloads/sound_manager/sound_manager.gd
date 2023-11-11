extends Node

const sound_script: Script = preload("res://autoloads/sound_manager/sound.gd")

func play_sound(sound: AudioStream) -> void:
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	
	audio_stream_player.set_script(sound_script)
	audio_stream_player.stream = sound
	audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	
	add_child(audio_stream_player)
	
	audio_stream_player.play()
