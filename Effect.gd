extends AnimatedSprite

func _on_animation_done():
	queue_free()
