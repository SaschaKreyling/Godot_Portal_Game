extends RigidBody3D
class_name GumBall

@onready var physic_collider: CollisionShape3D = $PhysicCollider
@onready var interact_collider: CollisionShape3D = $GlueArea/InteractCollider
@onready var gum_ball_mesh_instance: MeshInstance3D = $GumBallMesh
@onready var reset_timer: Timer = $ResetTimer

var rest_position : Vector3

var	is_used_as_glue : bool = false
var is_picked_up : bool = false
var is_idling : bool = true

func _ready() -> void:
	rest_position = global_position
	reset()

func reset() -> void:
	reset_timer.stop()
	global_position = rest_position
	freeze = true
	show()
	set_collider(true)

func get_holdable_component(object : Node3D) -> GluableComponent:
	var gluable_components : Array = object.find_children("*", "GluableComponent")
	if !gluable_components.is_empty():
		return gluable_components.pop_front()
	return null 

func set_collider(status : bool) -> void:
	physic_collider.disabled = !status
	interact_collider.disabled = !status

func set_hidden():
	hide()
	freeze = true
	set_collider(false)

func _on_hit_zone_body_entered(body: Node3D) -> void:
	var gluable_component = get_holdable_component(body)
	if gluable_component:
		
		reset_timer.stop()
		set_hidden.call_deferred()
		
		gluable_component.set_glued(self)
		is_used_as_glue = true


func _on_holdable_shape_component_picked_up() -> void:
	reset_timer.stop()
	freeze = false
	is_picked_up = true

func _on_holdable_shape_component_dropped() -> void:
	if reset_timer.is_stopped():
		reset_timer.start()
	is_picked_up = false

func _on_reset_timer_timeout() -> void:
	reset()
