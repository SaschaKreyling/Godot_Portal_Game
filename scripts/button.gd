extends StaticBody3D
class_name FloorButton

@onready var active_collider: CollisionShape3D = $ActiveCollider
@onready var deactive_collider: CollisionShape3D = $DeactiveCollider
@onready var button_deactive_mesh: MeshInstance3D = $ButtonDeactive
@onready var button_active_mesh: MeshInstance3D = $ButtonActive

var activated: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		print("pressed")
		setActivated()


func _on_activation_area_body_exited(body: Node3D) -> void:
	if(body.is_in_group("ButtonPresser")):
		print("released")
		setDeactivated()
