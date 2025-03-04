extends StaticBody3D
class_name FloorButton

@export_color_no_alpha var linkColor : Color

@onready var active_collider: CollisionShape3D = $ActiveCollider
@onready var deactive_collider: CollisionShape3D = $DeactiveCollider
@onready var button_deactive_mesh: MeshInstance3D = $ButtonDeactive
@onready var button_active_mesh: MeshInstance3D = $ButtonActive
@onready var identfier : Identifier = $Identifier

var currentActivators : Array = []
var activated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	identfier.color = linkColor
	setDeactivated()

func setActivated() -> void:
	activated = true
	active_collider.set_deferred("disable",false) 
	button_deactive_mesh.visible = false
	
	deactive_collider.set_deferred("disable",true) 
	button_active_mesh.visible = true

func setDeactivated() -> void:
	activated = false
	active_collider.set_deferred("disable",true)
	button_deactive_mesh.visible = true
	
	deactive_collider.set_deferred("disable",false)
	button_active_mesh.visible = false

func _on_activation_area_body_entered(body: Node3D) -> void:
	if(body.is_in_group("ButtonPresser")):
		currentActivators.append(body)
	activated = not currentActivators.is_empty()
	if activated:
		setActivated()

func _on_activation_area_body_exited(body: Node3D) -> void:
	if(body.is_in_group("ButtonPresser")):
		currentActivators.erase(body)
	activated = not currentActivators.is_empty()
	if not activated:
		setDeactivated()
