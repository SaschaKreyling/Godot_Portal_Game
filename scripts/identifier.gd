extends Node3D
class_name Identifier

var speed : float = 4
var color : Color

var material
@onready var identifierMesh: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	material = identifierMesh.get_surface_override_material(0)
	material.albedo_color = color
	identifierMesh.set_surface_override_material(0, material)

func _process(delta: float) -> void:
	if material.albedo_color != color:
		material.albedo_color = color
		identifierMesh.set_surface_override_material(0, material)
	rotate_y(speed * delta)
