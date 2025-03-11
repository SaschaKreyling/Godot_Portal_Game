extends Node3D

@onready var area: Area3D = $"."

@export var upButton : StandingButton
@export var downButton : StandingButton

func _ready() -> void:
	upButton.standing_button_pushed.connect(setUp)
	downButton.standing_button_pushed.connect(setDown)

func setGravity(direction) -> void:
	area.set_gravity_direction(direction)
		
func setUp():
	setGravity(Vector3.UP)

func setDown():
	setGravity(Vector3.DOWN)
