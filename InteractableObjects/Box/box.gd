extends RigidBody3D
class_name Box

@onready var collision_streamer: AudioStreamPlayer3D = $CollisionStreamer
var speed_factor : float = 1.5

func _on_body_entered(_body: Node) -> void:
	if(linear_velocity.length() > speed_factor):
		collision_streamer.play()
