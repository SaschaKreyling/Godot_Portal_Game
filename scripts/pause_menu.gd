extends Control

@onready var main = $"../../"

func _on_resume_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main.pauseMenu()

func _on_exit_to_main_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
