extends Control

@onready var ui: Node = $".."

func _on_resume_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ui.toggle_pause_menu()

func _on_exit_to_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(PathConstants.MAIN_MENU_PATH)

func _on_quit_pressed() -> void:
	get_tree().quit()
