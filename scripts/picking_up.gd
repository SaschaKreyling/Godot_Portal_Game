extends RayCast3D

@onready var holdingPoint: Node3D = $"../HoldingAncor"
@onready var camera: Camera3D = $".."

var throw_strength = -18.0
var pull_power : float = 4
var dropDistance : float = 3


var picked_object : Node3D
var collidor

func _physics_process(_delta: float) -> void:
	if picked_object != null:
		
		var objectPosition : Vector3 = picked_object.global_position
		var holdPosition : Vector3 = holdingPoint.global_position
		var collider : Node3D = get_collider()
		
		if(collider != null and collider.name == "PortalSurface"):
			var portal : Portal = collider.get_parent_node_3d()
			holdPosition = portal.hold.global_position
			
		var distanceToBeClosed = objectPosition.distance_to(holdPosition)
		if distanceToBeClosed > dropDistance:
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
	if is_pickupable(object):
		picked_object = object
		if object.has_method("togglePickedUp"):
			object.togglePickedUp()

func drop_object():
	if picked_object.has_method("togglePickedUp"):
			picked_object.togglePickedUp()
	picked_object = null

func is_pickupable(object) -> bool:
	return object != null and not picked_object and object.is_in_group("holdables")

func throw_object():
	if picked_object == null: 
		return
	
	var throw_direction = camera.global_transform.basis.z.normalized()
	
	picked_object.apply_impulse(throw_direction * throw_strength)
	picked_object = null
