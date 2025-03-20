extends Node3D

@onready var area: Area3D = $"."

@export var up_button : StandingButton
@export var down_button : StandingButton

func _ready() -> void:
	if up_button:
		up_button.standing_button_pushed.connect(set_gravity_up)
	if down_button:
		down_button.standing_button_pushed.connect(set_gravity_down)

func set_gravity(direction) -> void:
	area.set_gravity_direction(direction)
		
func set_gravity_up() -> void:
	set_gravity(Vector3.UP)

func set_gravity_down() -> void:
	set_gravity(Vector3.DOWN)
