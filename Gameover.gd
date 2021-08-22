extends Panel

func _on_retry():
	var current_root = get_node("/root/root")
	current_root.name = "billy"
	get_node("/root").add_child(load("res://game.tscn").instance())
	current_root.queue_free()

func _on_menu():
	var current_root = get_node("/root/root")
	get_node("/root").add_child(load("res://MainMenu.tscn").instance())
	current_root.queue_free()
