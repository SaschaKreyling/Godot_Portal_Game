extends StaticBody3D
class_name StandingButton

signal standing_button_pushed

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var push_sound_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var interaction_collider_component: InteractionColliderComponent = $InteractionColliderComponent

func _ready() -> void:
	interaction_collider_component.interacted.connect(interact)

func interact() -> void:
	if animation_player.is_playing():
		return
	animation_player.play("push")
	push_sound_stream_player.play()
	standing_button_pushed.emit()
