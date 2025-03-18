extends Control

func _on_play_pressed() -> void:
	SceneController.goto_scene_no_loading_screen("res://menus/level_select_menu.tscn")


func _on_options_pressed() -> void:
	SceneController.goto_scene_no_loading_screen("res://Menus/options_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
