extends Control

func _on_play_pressed() -> void:
	SceneController.goto_scene("res://menus/level_select_menu.tscn")
