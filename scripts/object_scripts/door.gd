extends StaticBody3D


@export var buttons : Array[FloorButton]
@export var open_other_direction: bool

@onready var front_identifier: Identifier = $FrontIdentifier
@onready var back_identifier: Identifier = $BackIdentifier

@onready var door_collider: CollisionShape3D = $DoorCollider
@onready var movable_door_mesh_instance: MeshInstance3D = $MovableDoor

var link_color : Color

var activated : bool = true
var opened_target : float = 3.025 
var open_time : float = 2
var direction : int

func _ready() -> void:
	direction = 1 if open_other_direction else -1 

func _process(delta: float) -> void:
	activated = areAllButtonsActive()
	if activated:
		door_collider.disabled = true
		if abs(movable_door_mesh_instance.position.z) <= opened_target:
			movable_door_mesh_instance.position.z += direction * max(delta * opened_target / open_time, abs(movable_door_mesh_instance.position.z) - opened_target)
		else:
			movable_door_mesh_instance.visible = false
	else:
		movable_door_mesh_instance.visible = true
		door_collider.disabled = false
		if abs(movable_door_mesh_instance.position.z) > 0:
			movable_door_mesh_instance.position.z -= direction * min(delta * opened_target / open_time , abs(movable_door_mesh_instance.position.z))

func areAllButtonsActive() -> bool:
	var active : bool = true
	for button in buttons:
		active = active and button.is_activated()
	return active

func set_link_color(color : Color) -> void:
	link_color = color
	front_identifier.update_color(link_color)
	back_identifier.update_color(link_color)
