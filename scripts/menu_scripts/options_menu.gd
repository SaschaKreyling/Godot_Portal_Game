extends Control


func _on_back_pressed() -> void:
	SceneController.goto_scene_no_loading("res://Menus/main_menu.tscn")
