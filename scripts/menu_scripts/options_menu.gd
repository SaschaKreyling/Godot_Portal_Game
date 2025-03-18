extends Control
@onready var volume_slider: HSlider = $VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/VolumeSlider


func _ready() -> void:
	volume_slider.value = SettingsManager.vfx_volume

func _on_back_pressed() -> void:
	SceneController.goto_scene_no_loading_screen("res://menus/main_menu.tscn")

func _on_volume_slider_value_changed(value: float) -> void:
	SettingsManager.vfx_volume = value
	print(SettingsManager.vfx_volume)
