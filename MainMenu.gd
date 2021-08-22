extends Control

func _ready():
	get_tree().paused = false
	
	var save_file = File.new()
	if not save_file.file_exists("user://HideyBoiDev.gamesave"):
		save_file.open("user://HideyBoiDev.gamesave", File.WRITE)
		
		var to_save = {
			"HIGHSCORE" : 0,
			"MUSIC_ENABLED" : false
		}
		
		save_file.store_var(to_save)
		save_file.close()
	
	save_file.open("user://HideyBoiDev.gamesave", File.READ)
	var game_save = save_file.get_var()
	
	$MusicCheck.pressed = game_save["MUSIC_ENABLED"]
	
	save_file.close()

func _on_play():
	get_node("/root").add_child(preload("res://game.tscn").instance())
	queue_free()

func _on_fullscreen_changed(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_music_toggle(button_pressed):
	var save_file = File.new()
	
	save_file.open("user://HideyBoiDev.gamesave", File.READ)
	
	var game_save = save_file.get_var()
	
	save_file.close()
	
	save_file.open("user://HideyBoiDev.gamesave", File.WRITE)
	
	var to_save = {
		"HIGHSCORE" : game_save["HIGHSCORE"],
		"MUSIC_ENABLED" : button_pressed
	}
		
	save_file.store_var(to_save)
	save_file.close()
