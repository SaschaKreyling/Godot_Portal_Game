extends Control


func _on_back_pressed() -> void:
	SceneController.goto_scene("res://Menus/main_menu.tscn")
