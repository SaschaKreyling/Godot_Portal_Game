extends RigidBody3D

@onready var collision_streamer: AudioStreamPlayer3D = $CollisionStreamer


var factor:float = 3
func _on_body_entered(body: Node) -> void:
	if(abs(linear_velocity.x) > factor or abs(linear_velocity.y) > factor or abs(linear_velocity.z) > factor):
		collision_streamer.play()
