extends MeshInstance3D

var bodies_in_water : Array = []
var float_factor : float = 3
var drag : float = 0.05

@onready var water_plane: MeshInstance3D = $"."

func _process(delta: float) -> void:
	for body in bodies_in_water:
		if(body is RigidBody3D):
			body.linear_damp = 1 
			body.angular_damp = 1
			var target_height : float = water_plane.global_position.y + 0.15
			var depth : float = target_height - body.global_position.y 
			var random_motion : Vector3 = Vector3(0,randf_range(-1,1),0) * 2
			body.apply_central_force(random_motion)
			if depth > 0:
				var force = Vector3.UP * float_factor * depth  * body.get_gravity().length()
				body.linear_damp = 1 - drag
				body.angular_damp = 1 - drag
				body.apply_central_force(force)


func _physics_process(delta: float) -> void:
	for body in bodies_in_water:
		if body is CharacterBody3D:
			var target_height : float = water_plane.global_position.y + 0.15
			var depth : float = target_height - body.global_position.y 
			var random_motion : Vector3 = Vector3(0,randf_range(-1,1),0) * 2
			body.velocity += 0.1 * random_motion
			if depth > 0:
				var force = Vector3.UP * float_factor * depth  * body.get_gravity().length()
				print(force)
				body.velocity *= 1 - drag
				body.velocity += 0.01 * force

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.reset_to_last_save_position()
	elif body is not GridMap:
		bodies_in_water.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	bodies_in_water.erase(body)
