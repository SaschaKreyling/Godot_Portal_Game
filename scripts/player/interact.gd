extends RayCast3D

@onready var holding_ancor : Node3D = $"../HoldingAncor"
@onready var camera: Camera3D = $".."

const throw_strength : float = -18.0
const pull_power : float = 10
const drop_distance : float = 4

var picked_object : Node3D
var interacted_portal : Portal

func _init() -> void:
	SignalBus.teleported_object.connect(_on_object_teleported)

func _physics_process(_delta: float) -> void:
	if picked_object != null:
		var target_holding_position : Vector3 =  interacted_portal.alternate_holding_ancor.global_position if interacted_portal else holding_ancor.global_position
		var distance_to_target_position : float = picked_object.global_position.distance_to(target_holding_position)
		var velocity_torwards_target : Vector3 = picked_object.global_position.direction_to(target_holding_position) * distance_to_target_position * pull_power
		picked_object.set_linear_velocity(velocity_torwards_target)
		if(distance_to_target_position > drop_distance):
			drop_object()

func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("interact"):
		var object : Node3D = get_looked_at_object()
		if object == null: return
		try_to_interact_with(object)
			
	if Input.is_action_just_pressed("pickup"):
		var object : Node3D = get_looked_at_object()
		if object == null: return
		try_to_pick_up(object)
	elif picked_object and Input.is_action_just_released("pickup"):
		drop_object()

	if Input.is_action_just_pressed("throw"):
		throw_object()

func get_looked_at_object() -> Node:
	var object : Node3D = get_collider()
	if(object and object.name == "PortalSurface"):
		interacted_portal = object.get_parent()
		object = interacted_portal.alternate_interact_ray_cast.get_collider()
	else:
		interacted_portal = null
	return object

func try_to_pick_up(object : Node3D) -> void:
	var holdable_component : HoldableShapeComponent = get_holdable_component(object)
	if holdable_component:
		picked_object = object
		holdable_component.pick_up()
		
func try_to_interact_with(object):
	var interaction_component : InteractionColliderComponent = get_interaction_component(object)
	if interaction_component:
		interaction_component.interact()

func drop_object() -> void:
	var holdable_component : HoldableShapeComponent = get_holdable_component(picked_object)
	holdable_component.drop()
	picked_object = null
	interacted_portal = null

func get_holdable_component(object : Node3D) -> HoldableShapeComponent:
	if object.has_node("HoldableShapeComponent"):
		return object.get_node("HoldableShapeComponent")
	return null 
	
func get_interaction_component(object : Node3D) -> InteractionColliderComponent:
	if object.has_node("InteractionColliderComponent"):
		return object.get_node("InteractionColliderComponent")
	return null 

func is_interactable(object) -> bool:
	return object and object.is_in_group("interactable")

func throw_object() -> void:
	if picked_object == null: 
		return
	var throw_direction : Vector3 = camera.global_basis.z.normalized()
	
	if interacted_portal:
		throw_direction = interacted_portal.portal_camera.global_basis.z.normalized()
		
	picked_object.apply_impulse(throw_direction * throw_strength)
	drop_object()

func _on_object_teleported(object : Node3D, destination : Portal) -> void:
		if not picked_object:
			return
		if(interacted_portal):
			interacted_portal = null
		elif(object == picked_object):
			interacted_portal = destination.linked_portal
		elif(object is Player):
			interacted_portal = destination
