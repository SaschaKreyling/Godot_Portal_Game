extends RigidBody3D
class_name GumBall

@onready var physic_collider: CollisionShape3D = $PhysicCollider
@onready var interact_collider: CollisionShape3D = $GlueArea/InteractCollider
@onready var gum_ball_mesh_instance: MeshInstance3D = $GumBallMesh
@onready var reset_timer : Timer = $ResetTimer

var start_position : Vector3

var	is_used_as_glue : bool = false
var is_picked_up : bool = false
var is_idling : bool = true

func _ready() -> void:
	start_position = global_position
	reset()

func _process(_delta: float) -> void:
	pass

func reset() -> void:
	pass

func glue_object(gluable_object) -> void:
	if gluable_object.set_glued(self):
		is_used_as_glue = true

func _on_hit_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("gluable"):
		glue_object(body)

func _on_timer_timeout() -> void:
	print("no time left")
	reset()

func _on_holdable_shape_component_picked_up() -> void:
	is_picked_up = true

func _on_holdable_shape_component_dropped() -> void:
	is_picked_up = false
