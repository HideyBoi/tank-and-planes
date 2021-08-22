extends Node2D

var rng := RandomNumberGenerator.new()

var player_health := 100
var player_score := 0
var player_highscore := 0

var music_enabled = false

var player_max_health := 100
var player_look_speed := 0.06
var player_look_barrel_speed := 0.13

var time_before_next_spawn := [1.3, 10.3]

var enemies_spawned := 0

var easy_enemy := preload("res://Prefabs/Enemy.tscn")
var med_enemy := preload("res://Prefabs/Enemy_02.tscn")
var hard_enemy := preload("res://Prefabs/Enemy_03.tscn")
var hit_sound := preload("res://Prefabs/HitNoise.tscn")
var PowerUpPopUp := preload("res://Prefabs/PowerUpPopUP.tscn")
onready var root = get_node_or_null("/root/root")
onready var player = get_node_or_null("/root/root/Player")
onready var HealthBar = get_node_or_null("/root/root/UI Canvas/UI/HealthBar")
onready var CurrentHealth = get_node_or_null("/root/root/UI Canvas/UI/CurrentHealth")
onready var MaxHealth = get_node_or_null("/root/root/UI Canvas/UI/MaxHealth")
onready var UIRoot = get_node_or_null("/root/root/UI Canvas/UI")
onready var Score = get_node_or_null("/root/root/UI Canvas/UI/Score")
onready var HighScore = get_node_or_null("/root/root/UI Canvas/UI/Highscore")
onready var Gameover_screen = get_node_or_null("/root/root/UI Canvas/UI/Gameover")

var propability := [0, 6]

func _ready():
	get_tree().paused = false
	
	var timer = Timer.new()
	timer.name = "Timer"
	add_child(timer)
	$Timer.set_wait_time(rng.randf_range(time_before_next_spawn[0], time_before_next_spawn[1]))
	$Timer.set_one_shot(true)
	$Timer.start()
	
	get_node("/root/root/Camera2D").current = true
	
	var save_game = File.new()

	save_game.open("user://HideyBoiDev.gamesave", File.READ)
	var game_save = save_game.get_var()
	
	player_highscore = game_save["HIGHSCORE"]
	music_enabled = game_save["MUSIC_ENABLED"]
	
	$AudioStreamPlayer.playing = music_enabled
	
	save_game.close()

func _process(_delta):
	
	if player_health < 0:
		player_health = 0
	
	HealthBar.max_value = player_max_health
	HealthBar.value = player_health
	MaxHealth.bbcode_text = str(player_max_health)
	CurrentHealth.bbcode_text = "[right]" + str(player_health)
	Score.text = "Score: " + str(player_score)
	if player_score > player_highscore:
		HighScore.text = "Highscore: " + str(player_score)
	else:
		HighScore.text = "Highscore: " + str(player_highscore)
	
	if $Timer.time_left <= 0:
		var prop = rng.randi_range(0, 45)
		var to_spawn = null
		if prop > propability[1]:
			to_spawn = easy_enemy.instance() 
		else: 
			if prop > propability[0]:
				to_spawn = med_enemy.instance()
			else:
				to_spawn = hard_enemy.instance()
		if propability[0] < 12:
			propability[0] += 1
		if propability[1] < 20:
			propability[1] += 2
	
		if time_before_next_spawn[1] > 6:
			time_before_next_spawn[1] -= 1

		to_spawn.rotation = rng.randi_range(0, 360)
		root.add_child(to_spawn)
		
		$Timer.set_wait_time(rng.randf_range(time_before_next_spawn[0], time_before_next_spawn[1]))
		$Timer.start()

func enemy_killed(score : int):
	if player == null:
		print("NULL")
		return

	player.health += 25
	
	player_score += score

	if player.health > player_max_health:
		player.health = player_max_health
	
	powerup()

func hit_something(pos : Vector2):
	var noise = hit_sound.instance()
	noise.position = pos
	root.add_child(noise)

func powerup():
	if player == null:
		return
	
	var powerup_chances = [3-0, 54, 60]
	var rand = rng.randi_range(0, 100)
	if rand > powerup_chances[0]:
		if rand > powerup_chances[1]:
			if rand > powerup_chances[2]:
				player_health += 10
				display_powerup_message("+10 max health!")
				print("+10")
				return
			player_max_health += 5
			display_powerup_message("+5 max health!")
			print("+5")
			return
		player_max_health += 1
		display_powerup_message("+1 max health!")
		print("+1")
	else:
		return

func display_powerup_message(msg):
	var inst = PowerUpPopUp.instance()
	inst.get_node("Text").bbcode_text = "[center]" + msg
	UIRoot.add_child(inst)

func you_lost_lmao_bad():
	yield(get_tree().create_timer(0.8), "timeout")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Gameover_screen.visible = true
	get_tree().paused = true
	
	if player_score > player_highscore:
		var save_game = File.new()
		save_game.open("user://HideyBoiDev.gamesave", File.WRITE)
		
		var to_save = {
			"HIGHSCORE" : player_score,
			"MUSIC_ENABLED" : music_enabled
		}
		
		save_game.store_var(to_save)
		save_game.close()
