extends Node3D
class_name Identifier

var speed : float = 4

@onready var identifier_mesh_instance: MeshInstance3D = $IdentifierMesh
@onready var identifier_light: OmniLight3D = $IdentifierLight

func _process(delta: float) -> void:
	rotate_object_local(Vector3(0,1,0),speed * delta)

func update_color(color : Color) -> void:
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	identifier_light.light_color = color
	identifier_mesh_instance.set_surface_override_material(0, material)
