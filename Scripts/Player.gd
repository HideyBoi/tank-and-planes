extends Area2D

var health = 100
var atk_dmg = 15

var lookSpeed := 0.06
var barrelSpeed := 0.13
onready var barrel := get_node("/root/root/Barrel")
onready var shootPoint := get_node("/root/root/Barrel/ShootPoint")
onready var level_root := get_node("/root/root")
onready var Game_Master := get_node("/root/root/GameMaster")

var bullet = preload("res://Prefabs/Bullet.tscn")
var muzzle_flash = preload("res://Prefabs/MuzzleFlash.tscn")
var explosion = preload("res://Prefabs/Explosion.tscn")

var is_touch = false
var is_shoot = false

var lookDir = Vector2(0, 0)

func _process(_delta):
	_process_rotation()
	
	Game_Master.player_health = health
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if health <= 0:
		var boom = explosion.instance()
		boom.global_position = global_position
		level_root.add_child(boom)
		
		Game_Master.you_lost_lmao_bad()
		Game_Master.player = null
		barrel.queue_free()
		queue_free()

func shoot():
	var bulletInst = bullet.instance()
	bulletInst.position = shootPoint.global_position
	bulletInst.rotation = barrel.rotation
	bulletInst.damage = atk_dmg
	level_root.add_child(bulletInst)
	
	var muzzle = muzzle_flash.instance()
	muzzle.position = shootPoint.global_position
	muzzle.rotation = barrel.rotation
	level_root.add_child(muzzle)

func _input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		print("touch")
		is_shoot = true
		
		shoot()

func _process_rotation():
	if not is_touch:
		lookDir = (get_global_mouse_position() - position)
	
	var desRot = lookDir.angle()
	
	var max_angle := PI * 2
	var difference := fmod(desRot - rotation, max_angle)
	rotation += (fmod(2 * difference, max_angle) - difference) * lookSpeed
	
	var lookDir2 := Vector2()
	lookDir2 = (get_global_mouse_position() - position)
	
	var desRot2 = lookDir2.angle()
	
	var max_angle2 := PI * 2
	var difference2 := fmod(desRot2 - barrel.rotation, max_angle2)
	barrel.rotation += (fmod(2 * difference2, max_angle2) - difference2) * barrelSpeed


func _on_hit(body):
	if body.is_in_group("enemy_bullet"):
		health -= body.damage
