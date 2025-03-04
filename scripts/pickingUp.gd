extends RayCast3D

@onready var holdingPoint: Node3D = $"../Hold"

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
