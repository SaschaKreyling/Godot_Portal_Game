extends Node3D

@onready var area: Area3D = $"."
@onready var player: Player = %Player
signal gravity_turned(gravity: int)

var gravity_normal: bool = true
var up = Vector3(0, 1, 0)
var down = Vector3(0, -1, 0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("gravity"):
		if(gravity_normal == true):
			gravity(up)
			gravity_normal = false
		elif(gravity_normal != true):
			gravity(down)
			gravity_normal = true


func gravity(direction):
	area.set_gravity_direction(direction)
	
	var target_rotation
	if direction == up:
		target_rotation = 180
		emit_signal("gravity_turned", -1)
	else:
		target_rotation = 0
		emit_signal("gravity_turned", 1)
