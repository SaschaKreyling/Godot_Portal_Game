extends RayCast3D

@onready var holdingPoint: Node3D = $"../Hold"
@onready var camera: Camera3D = $".."

var pickedUp : bool = false
var collider : CollisionObject3D

func _process(_delta: float) -> void:
	target_position = holdingPoint.position
	
	if Input.is_action_just_pressed("Interact"):
		collider  = get_collider()
		if  collider != null and not pickedUp and collider.is_in_group("holdables"):
			pickedUp = true
		else:
			pickedUp = false
	
	if pickedUp and collider != null:
		collider.global_position = holdingPoint.global_position
	
	if Input.is_action_just_pressed("throw"):
		throw_object()


func throw_object():
	if collider == null:
		return
	
	var throw_direction = camera.global_transform.basis.z.normalized()
	var throw_strength = -18.0
	var upDirection = 5
	
	pickedUp = false
	collider.apply_impulse(throw_direction * throw_strength + Vector3(0, upDirection, 0))
	collider = null
