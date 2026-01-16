extends Control

func _on_play_pressed() -> void:
	SceneController.goto_scene_no_loading_screen(PathConstants.LEVEL_SELECT_PATH)


func _on_options_pressed() -> void:
	SceneController.goto_scene_no_loading_screen(PathConstants.OPTIONS_PATH)


func _on_exit_pressed() -> void:
	get_tree().quit()
