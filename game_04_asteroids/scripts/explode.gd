extends CPUParticles2D

func _ready() -> void:
	emitting = true

func _on_finished() -> void:
	if not $AudioStreamPlayer.playing:
		queue_free()

func _on_audio_stream_player_finished() -> void:
	if not emitting:
		queue_free()
