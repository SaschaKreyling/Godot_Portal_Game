extends Node3D

@onready var area: Area3D = $"."
signal gravity_turned(gravity: int)

var gravity_normal: bool = true
var up = Vector3(0, 1, 0)
var down = Vector3(0, -1, 0)

@export var upButton : StandingButton
@export var downButton : StandingButton

func _ready() -> void:
	upButton.standing_button_pushed.connect(setUp)
	downButton.standing_button_pushed.connect(setDown)

func gravity(direction) -> void:
	area.set_gravity_direction(direction)
	
	var target_rotation
	if direction == up:
		gravity_normal = false
		target_rotation = 180
		emit_signal("gravity_turned", -1)
	else:
		gravity_normal = true
		target_rotation = 0
		emit_signal("gravity_turned", 1)
		
func setUp():
	gravity(up)
func setDown():
	gravity(down)
