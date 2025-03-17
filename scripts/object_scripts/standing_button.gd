extends StaticBody3D
class_name StandingButton

signal standing_button_pushed

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var standing_button_mesh: MeshInstance3D = $StandingButtonMesh


func interact() -> void:
	if animation_player.is_playing():
		return
	animation_player.play("push")
	audio_stream_player_3d.play()
	emit_signal("standing_button_pushed")

func setHighlighted(material: ShaderMaterial):
	pass
