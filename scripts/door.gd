extends StaticBody3D


@export var buttons : Array[FloorButton]
@export var openOtherDirection: bool
@export_color_no_alpha var linkColor : Color

@onready var frontIdentifier: Identifier = $FrontIdentifier
@onready var backIdentifier: Identifier = $BackIdentifier

@onready var doorCollider: CollisionShape3D = $DoorCollider
@onready var movableDoor: MeshInstance3D = $MovableDoor


var activated : bool = true
var openedTarget : float = 3.025 
var openTime : float = 2;
var direction : int

func _ready() -> void:
	frontIdentifier.updateColor(linkColor)
	backIdentifier.updateColor(linkColor)
	direction = 1 if openOtherDirection else -1 

func _process(delta: float) -> void:
	activated = areAllButtonsActive()
	if activated:
		doorCollider.disabled = true
		if abs(movableDoor.position.z) <= openedTarget:
			movableDoor.position.z += direction * max(delta * openedTarget / openTime, abs(movableDoor.position.z) - openedTarget)
		else:
			movableDoor.visible = false
	else:
		movableDoor.visible = true
		doorCollider.disabled = false
		if abs(movableDoor.position.z) > 0:
			movableDoor.position.z -= direction * min(delta * openedTarget / openTime , abs(movableDoor.position.z))


func areAllButtonsActive() -> bool:
	var active : bool = true
	for button in buttons:
		active = active and button.activated
	return active
