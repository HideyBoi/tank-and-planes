extends Area2D

var speed := 450
var damage := 0

onready var Game_Master := get_node("/root/root/GameMaster")

func _on_hit(body):
	if body.is_in_group("player"):
		Game_Master.hit_something(global_position)
		queue_free()
	if body.is_in_group("player_bullet"):
		Game_Master.hit_something(global_position)
		body.queue_free()
		queue_free()

func _on_time_up():
	queue_free()

func _process(delta):
	position -= to_global(Vector2.UP * speed) * delta
