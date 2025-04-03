extends CharacterBody3D

const SPEED = 6


@export var assigned_box : Box

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var path_finding_timer: Timer = $PathFindingTimer

var glued : bool
var target_position : Vector3
var target_direction : Vector3 = Vector3()
var portals_in_scene : Array[Portal]

func _ready() -> void:
	SignalBus.teleported_object.connect(_on_object_teleported)
	portals_in_scene.assign(get_tree().get_root().find_children("*", "Portal", true, false))

func _physics_process(delta: float) -> void:
	target_position = get_close_navigable_position(assigned_box.global_position)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if is_on_floor() and not glued:
		var steering : Vector3 = target_direction - velocity.normalized()
		velocity += steering * 2
		velocity = velocity.normalized() * SPEED

	move_and_slide()

func get_close_navigable_position(point : Vector3) -> Vector3:
	if NavigationServer3D.map_is_active(navigation_agent.get_navigation_map()):
		var nav_map = navigation_agent.get_navigation_map()
		return NavigationServer3D.map_get_closest_point(nav_map, point)
	return point

func direction_to_target() -> Vector3:
	navigation_agent.target_position = target_position
	return global_position.direction_to(navigation_agent.get_next_path_position())

func _on_path_finding_timer_timeout() -> void:
	if glued: return
	target_direction = direction_to_target()

func _on_gluable_component_glued() -> void:
	glued = true

func _on_gluable_component_unglued() -> void:
	glued = false

func _on_object_teleported(object : Node3D, destination : Portal) -> void:
	if object == self and not glued:
		var portal_normal : Vector3 = destination.global_basis.z
		var direction_to_portal : Vector3 = global_position.direction_to(destination.global_position)
		var side_of_portal : float = -sign(portal_normal.dot(direction_to_portal))
		velocity = portal_normal * side_of_portal * 2 * SPEED
		target_direction = direction_to_target()
