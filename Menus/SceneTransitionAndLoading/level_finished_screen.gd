extends Control

func _on_play_pressed() -> void:
	SceneController.goto_scene("res://menus/main_menus/level_select_menu.tscn")
