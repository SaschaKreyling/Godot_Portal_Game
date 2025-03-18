extends RayCast3D

@onready var holding_ancor: Node3D = $"../HoldingAncor"
@onready var camera: Camera3D = $".."

const throw_strength : float = -18.0
const pull_power : float = 10
const drop_distance : float = 4

var picked_object : Node3D
var interacted_portal : Portal

func _ready() -> void:
	SignalBus.teleported_object.connect(_on_object_teleported)

func _physics_process(_delta: float) -> void:
	if picked_object != null:
		var object_position : Vector3 = picked_object.global_position
		var target_holding_position : Vector3 = holding_ancor.global_position
		
		var is_out_of_reach : bool = false
		if interacted_portal:
			target_holding_position = interacted_portal.alternate_holding_ancor.global_position
			
			var direction_To_other_portal_surface = interacted_portal.portal_camera.global_basis.z
			var dot_object : float = direction_To_other_portal_surface.dot(interacted_portal.linked_portal.global_basis.z)
			is_out_of_reach = sign(dot_object) > 1
			
		var distance_to_target_position : float = object_position.distance_to(target_holding_position)
		if(distance_to_target_position > drop_distance or is_out_of_reach):
			drop_object()
			return
		picked_object.set_linear_velocity(object_position.direction_to(target_holding_position) * distance_to_target_position * pull_power)

func _process(_delta: float) -> void:
	var object = get_collider()
	if Input.is_action_just_pressed("Interact"):
		
		if(object and object.name == "PortalSurface"):
			var portal : Portal = object.get_parent_node_3d()
			object = portal.alternate_interact_ray_cast.get_collider()
			interacted_portal = portal
			
		if is_interactable(object):
			object.interact()
		toggle_pick_up(object)
				
	if Input.is_action_just_pressed("throw"):
		throw_object()

func toggle_pick_up(object):
	if picked_object == null:
		pick_object(object)
	elif picked_object != null:
		drop_object()

func pick_object(object):
	if is_pickupable(object):
		picked_object = object
		if object.has_method("toggle_picked_up"):
			object.toggle_picked_up()

func drop_object():
	if picked_object.has_method("toggle_picked_up"):
		picked_object.toggle_picked_up()
	picked_object = null
	interacted_portal = null

func is_pickupable(object) -> bool:
	return object and object.is_in_group("holdable")
	
func is_interactable(object) -> bool:
	return object and object.is_in_group("interactable")

func throw_object():
	if picked_object == null: 
		return
	var throw_direction = camera.global_basis.z.normalized()
	
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
