extends StaticBody3D
class_name FloorButton

@export_color_no_alpha var linkColor : Color
@export var unglue : bool = false

@onready var active_collider: CollisionShape3D = $ActiveCollider
@onready var deactive_collider: CollisionShape3D = $DeactiveCollider

@onready var button_deactive_mesh: MeshInstance3D = $ButtonDeactive
@onready var button_active_mesh: MeshInstance3D = $ButtonActive
@onready var button_glued_mesh: MeshInstance3D = $ButtonGlued

@onready var identfier : Identifier = $Identifier

var currentActivators : Array = []
var activated: bool = false

var glued: bool = false
var currentGumBall: GumBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	identfier.updateColor(linkColor)
	setDeactivated()

func _process(delta: float) -> void:
	if unglue:
		unglue = false
		setUnglued()

func setGlued(gumBall : GumBall) -> bool:
	if(not activated or glued):
		return false
			
	glued = true
	activated = true
	currentGumBall = gumBall
	
	active_collider.set_deferred("disable", false)
	button_glued_mesh.visible = true
	
	deactive_collider.set_deferred("disable", true) 
	button_deactive_mesh.visible = false
	
	button_active_mesh.visible = false
	
	return true

func setUnglued() -> void:
	if glued:
		glued = false
		currentGumBall.reset()
		currentGumBall = null
		updateState()

func setActivated() -> void:
	glued = false
	activated = true

	active_collider.set_deferred("disable", false) 
	button_active_mesh.visible = true
	
	deactive_collider.set_deferred("disable", true) 
	button_deactive_mesh.visible = false
	
	button_glued_mesh.visible = false

func setDeactivated() -> void:
	glued = false
	activated = false
		
	deactive_collider.set_deferred("disable", false)
	button_deactive_mesh.visible = true
	
	active_collider.set_deferred("disable", true)
	button_active_mesh.visible = false
	
	button_glued_mesh.visible = false

func updateState():
	activated = not currentActivators.is_empty() or glued
	if not glued:
		if activated:
			setActivated()
		else:
			setDeactivated()

func _on_activation_area_body_entered(body: Node3D) -> void:
	if(body.is_in_group("presser")):
		currentActivators.append(body)
	updateState()

func _on_activation_area_body_exited(body: Node3D) -> void:
	if(body.is_in_group("presser")):
		currentActivators.erase(body)
	updateState()
