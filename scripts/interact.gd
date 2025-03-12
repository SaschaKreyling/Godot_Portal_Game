extends RayCast3D

@onready var holdingAncor: Node3D = $"../HoldingAncor"
@onready var camera: Camera3D = $".."

const throw_strength : float = -18.0
const pull_power : float = 10
const dropDistance : float = 4

var picked_object : Node3D
var throughPortal : Portal

func _ready() -> void:
	SignalBus.teleported_object.connect(_on_object_teleported)

func _physics_process(_delta: float) -> void:
	if picked_object != null:
		var objectPosition : Vector3 = picked_object.global_position
		var holdPosition : Vector3 = holdingAncor.global_position
		
		var outOfReach : bool = false
		if throughPortal:
			holdPosition = throughPortal.alternateholdingAncor.global_position
			
			var directionToOtherPortalSurface = throughPortal.portalCamera.global_basis.z
			var dotObject : float = directionToOtherPortalSurface.dot(throughPortal.linkedPortal.global_basis.z)
			outOfReach = sign(dotObject) > 1
			
		var distanceToBeClosed : float = objectPosition.distance_to(holdPosition)
		if(distanceToBeClosed > dropDistance or outOfReach):
			drop_object()
			return
		picked_object.set_linear_velocity(objectPosition.direction_to(holdPosition) * distanceToBeClosed * pull_power)


func _process(delta: float) -> void:
	var object = get_collider()
	
	if(object != null):
		if Input.is_action_just_pressed("Interact"):
			
			if(object.name == "PortalSurface"):
				var portal : Portal = object.get_parent_node_3d()
				object = portal.alternateInteractRayCast.get_collider()
				throughPortal = portal
				
			if is_interactable(object):
				object.interact()
			else:
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
		if object.has_method("togglePickedUp"):
			object.togglePickedUp()

func drop_object():
	if picked_object.has_method("togglePickedUp"):
		picked_object.togglePickedUp()
	picked_object = null
	throughPortal = null

func is_pickupable(object) -> bool:
	return object.is_in_group("holdable")
	
func is_interactable(object) -> bool:
	return object.is_in_group("interactable")

func throw_object():
	if picked_object == null: 
		return
	var throw_direction = camera.global_basis.z.normalized()
	
	if throughPortal:
		throw_direction = throughPortal.portalCamera.global_basis.z.normalized()
		
	picked_object.apply_impulse(throw_direction * throw_strength)
	drop_object()

func _on_object_teleported(object : Node3D, destination : Portal) -> void:
		if not picked_object:
			return
		if(throughPortal):
			throughPortal = null
		elif(object == picked_object):
			throughPortal = destination.linkedPortal
		elif(object is Player):
			throughPortal = destination
