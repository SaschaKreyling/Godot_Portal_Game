extends RayCast3D

@onready var holdingAncor: Node3D = $"../HoldingAncor"
@onready var camera: Camera3D = $".."

var throw_strength = -18.0
var pull_power : float = 10
var dropDistance : float = 3


var picked_object : Node3D

var throughPortal : Portal

var active_ray : RayCast3D = self
var activeHoldingPoint : Node3D = holdingAncor

func _ready() -> void:
	SignalBus.teleported_object.connect(_on_object_teleported)

func _physics_process(_delta: float) -> void:
	if picked_object != null:
		var objectPosition : Vector3 = picked_object.global_position
		var holdPosition : Vector3 = holdingAncor.global_position
		
		var behindPortal = false
		if throughPortal:
			
			holdPosition = throughPortal.alternateholdingAncor.global_position
			
			var objectToPortalDirection = throughPortal.portalCamera.global_basis.z
			var dotObject : float = objectToPortalDirection.dot(throughPortal.global_basis.z)
			
			behindPortal = 1 == sign(dotObject)
			
		var distanceToBeClosed = objectPosition.distance_to(holdPosition)
		
		if(distanceToBeClosed > dropDistance or behindPortal):
			drop_object()
			return
			
		picked_object.set_linear_velocity(objectPosition.direction_to(holdPosition) * distanceToBeClosed * pull_power)


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Interact"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			drop_object()
			
	if Input.is_action_just_pressed("throw"):
		throw_object()

func pick_object():
	var object  = get_collider()
	throughPortal = null
	
	if(object != null and object.name == "PortalSurface"):
		var portal : Portal = object.get_parent_node_3d()
		object = portal.alternateInteractRayCast.get_collider()
		throughPortal = portal
		
	if is_pickupable(object):
		picked_object = object
		if object.has_method("togglePickedUp"):
			object.togglePickedUp()
	
	if object != null and object.is_in_group("interactable"):
		object.interact()
		
func drop_object():
	if picked_object.has_method("togglePickedUp"):
			picked_object.togglePickedUp()
	picked_object = null
	throughPortal = null

func is_pickupable(object) -> bool:
	return object != null and not picked_object and object.is_in_group("holdables")

func throw_object():
	if picked_object == null: 
		return
	var throw_direction = camera.global_basis.z.normalized()
	
	if throughPortal:
		throw_direction = throughPortal.portalCamera.global_basis.z.normalized()
		
	picked_object.apply_impulse(throw_direction * throw_strength)
	drop_object()

func _on_object_teleported(object : Node3D, destination : Portal) -> void:
		if(throughPortal):
			throughPortal = null
		elif(object == picked_object):
			throughPortal = destination.linkedPortal
		elif(object is Player):
			throughPortal = destination
