extends RayCast3D

@onready var holdingPoint: Node3D = $"../HoldingAncor"
@onready var camera: Camera3D = $".."

var pickedUp : bool = false
var picked_object : Node3D
var collidor
var pull_power : float = 4
var dropDistance : float = 3

func _physics_process(_delta: float) -> void:
	if picked_object != null:
		var a : Vector3 = picked_object.global_position
		var b : Vector3 = holdingPoint.global_position
		var collider : Node3D = get_collider()
		if(collider != null and collider.name == "PortalSurface"):
			var portal : Portal = collider.get_parent_node_3d()
			b = portal.hold.global_position
		if a.distance_to(b) > dropDistance:
			remove_object()
			return
		picked_object.set_linear_velocity((b-a) * pull_power)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			remove_object()

	if Input.is_action_just_pressed("throw"):
		throw_object()

func pick_object():
	var collider  = get_collider()
	if  collider != null and not pickedUp and collider.is_in_group("holdables"):
		picked_object = collider

func remove_object():
	picked_object = null

func throw_object():
	if picked_object == null or Engine.time_scale == 0 :
		return
	
	var throw_direction = camera.global_transform.basis.z.normalized()
	var throw_strength = -18.0
	#var upDirection = 5
	var upDirection = 0
	
	pickedUp = false	#glaube der bumms ist unnötig?
	picked_object.apply_impulse(throw_direction * throw_strength + Vector3(0, upDirection, 0))
	picked_object = null
