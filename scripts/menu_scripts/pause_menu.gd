extends Control

@onready var ui: Node = $".."

func _on_resume_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.togglePauseMenu()

func _on_exit_to_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
