extends Node2D

var rng := RandomNumberGenerator.new()
export var distance_range = [0, 360]
export var speed := 0.003

var des_dist := 0
var shift_dist := 5
var shift_dist2 := 2


func _ready():
	rng.randomize()
	
	des_dist = rng.randi_range(distance_range[0], distance_range[1])

func _process(_delta):
	
	var desRot = des_dist
	
	var max_angle := PI * 2
	var difference := fmod(desRot - rotation, max_angle)
	
	if difference > shift_dist:
		new_des_rot()
	if difference < shift_dist2:
		new_des_rot()
	
	rotation += (fmod(2 * difference, max_angle) - difference) * speed
	
func new_des_rot():
	des_dist = rng.randi_range(distance_range[0], distance_range[1])
