extends RayCast3D

var object = null
var key = KEY_E
@onready var point = $"../Camera3D/Hold"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_key_pressed(key):
		if object == null:
			var collider = get_collider()
			if collider != null:
				if collider.is_in_group("holdables"):
					object = collider
		
		if object != null:
			object.position = point.global_position
	else:
		object = null
