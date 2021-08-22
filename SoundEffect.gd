extends AudioStreamPlayer2D

func _done_playing():
	queue_free()
