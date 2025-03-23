extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var my_box : Box

@onready var disturb_bot_mesh: MeshInstance3D = $DisturbBotMesh
@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@onready var path_finding_timer: Timer = $PathFindingTimer

var glued : bool
var target_direction : Vector3 = Vector3()

@onready var next = global_position
func _physics_process(delta: float) -> void:
	if my_box:
		navigation.target_position = get_close_navigable_position(my_box.global_position)
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var steering : Vector3 = SPEED * target_direction - velocity
	velocity += steering * 0.1
	
	move_and_slide()


func _on_path_finding_timer_timeout() -> void:
	next = navigation.get_next_path_position()
	if not navigation.is_target_reached():
		target_direction = global_position.direction_to(next)

func get_close_navigable_position(point : Vector3) -> Vector3:
	var nav_map = navigation.get_navigation_map()
	return NavigationServer3D.map_get_closest_point(nav_map, point)

func _on_gluable_component_glued() -> void:
	pass # Replace with function body.

func _on_gluable_component_unglued() -> void:
	pass # Replace with function body.
