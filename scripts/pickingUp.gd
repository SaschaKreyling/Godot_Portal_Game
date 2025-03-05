extends RayCast3D

@onready var holdingPoint: Node3D = $"../Hold"
@onready var camera: Camera3D = $".."

var pickedUp : bool = false
var picked_object
var collidor
var pull_power = 4

func _physics_process(delta: float) -> void:
	if picked_object != null:
		var a = picked_object.global_position
		var b = holdingPoint.global_position
		picked_object.set_linear_velocity((b-a) * pull_power)

func _process(_delta: float) -> void:
	target_position = holdingPoint.position
	
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
	if picked_object != null:
		picked_object = null

func throw_object():
	if picked_object == null:
		return
	
	var throw_direction = camera.global_transform.basis.z.normalized()
	var throw_strength = -18.0
	var upDirection = 5
	
	pickedUp = false
	picked_object.apply_impulse(throw_direction * throw_strength + Vector3(0, upDirection, 0))
	picked_object = null
