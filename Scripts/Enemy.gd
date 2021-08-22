extends Area2D

export var health := 25
export var score := 100

var rng := RandomNumberGenerator.new()
export var distance_range = [-800, -150]
export var speed := 430

var des_dist := 0

export var shoot_time := [0.7, 1.8]
export var attack_dmg := 20

var bullet = preload("res://Prefabs/Enemy_Bullet.tscn")
var explosion = preload("res://Prefabs/Explosion.tscn")
var muzzle_flash = preload("res://Prefabs/MuzzleFlash.tscn")
onready var level_root := get_node("/root/root")
onready var Game_Master := get_node("/root/root/GameMaster")

func _ready():
	rng.randomize()
	
	des_dist = rng.randi_range(distance_range[0], distance_range[1])

func _process(delta):
	if position.y < des_dist:
		position.y += speed * delta

	if health <= 0:
		var boom = explosion.instance()
		boom.global_position = global_position
		level_root.add_child(boom)
		Game_Master.enemy_killed(score)
		get_parent().queue_free()


func _on_hit(body):
	if body.is_in_group("player_bullet"):
		health -= body.damage


func _on_Shoot():
	$Shoot.wait_time = rng.randf_range(shoot_time[0], shoot_time[1])
	$Shoot.start()
	
	var muzzle = muzzle_flash.instance()
	muzzle.position = $ShootPoint.global_position
	muzzle.rotation_degrees = global_rotation_degrees + 90
	level_root.add_child(muzzle)
	
	var bulletInst = bullet.instance()
	bulletInst.position = $ShootPoint.global_position
	bulletInst.rotation = global_rotation
	bulletInst.damage = attack_dmg
	level_root.add_child(bulletInst)
