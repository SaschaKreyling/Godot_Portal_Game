extends RigidBody3D

@onready var collision_streamer: AudioStreamPlayer3D = $CollisionStreamer


var speed_factor:float = 1.5

func _on_body_entered(_body: Node) -> void:
	if(abs(linear_velocity.x) > speed_factor
		or abs(linear_velocity.y) > speed_factor
		or abs(linear_velocity.z) > speed_factor):
		collision_streamer.play()
