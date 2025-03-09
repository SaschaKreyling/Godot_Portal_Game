extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade() -> void:
	fadeIn()
	fadeOut()

func fadeIn() -> void:
	animation_player.play("fade_in")
	
func fadeOut() -> void:
	animation_player.play("fade_out")
