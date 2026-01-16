extends Control

@onready var volume_slider: HSlider = $VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/VolumeSlider

func _ready() -> void:
	volume_slider.value = SettingsManager.get_voice_volume()

func _on_back_pressed() -> void:
	SceneController.goto_scene_no_loading_screen(PathConstants.MAIN_MENU_PATH)

func _on_volume_slider_value_changed(value: float) -> void:
	SettingsManager.set_voice_volume(value)
	print(SettingsManager.get_voice_volume())
