extends RigidBody3D
class_name GumBall

@onready var physic_collider: CollisionShape3D = $PhysicCollider
@onready var interact_collider: CollisionShape3D = $HitZone/InteractCollider
@onready var gum_ball_mesh_instance: MeshInstance3D = $GumBallMesh
@onready var reset_timer : Timer = $ResetTimer

var start_position : Vector3

var	is_used_as_glue : bool = false
var glued_object

var is_picked_up : bool = false
var is_idling : bool = true

func _ready() -> void:
	start_position = global_position
	reset()

func _process(_delta: float) -> void:
	if(global_position != start_position):
		cancel_idling()
		
	if is_not_on_ground():
		reset_timer.start(5)

func reset() -> void:
	set_shown()
	set_idling()
	reset_timer.stop()
	glued_object = null
	is_used_as_glue = false

func is_not_on_ground() -> bool:
	return is_picked_up or is_used_as_glue or is_idling
	
func set_hidden() -> void:
	physic_collider.set_deferred("disabled", true) 
	interact_collider.set_deferred("disabled", true) 
	global_position = Vector3(-1000,-1000,-1000)
	linear_velocity = Vector3(0,0,0)
	gum_ball_mesh_instance.visible = false

func set_shown() -> void:
	gum_ball_mesh_instance.visible = true
	physic_collider.set_deferred("disabled", false) 
	interact_collider.set_deferred("disabled", false) 

func set_idling() -> void:
	is_idling = true
	linear_velocity = Vector3(0,0,0)
	angular_velocity = Vector3(0,1,0)
	global_position = start_position
	gravity_scale = 0

func cancel_idling() -> void:
	gravity_scale = 1
	is_idling = false

func glue_object(gluable_object) -> void:
	if gluable_object.set_glued(self):
		is_used_as_glue = true
		glued_object = gluable_object
		set_hidden()

func _on_hit_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("gluable"):
		glue_object(body)

func _on_timer_timeout() -> void:
	reset()

func _on_holdable_shape_component_picked_up() -> void:
	is_picked_up = true

func _on_holdable_shape_component_dropped() -> void:
	is_picked_up = false
