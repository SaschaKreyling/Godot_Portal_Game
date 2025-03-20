extends Control

@export var indtroduction_level_path : String
@export var testing_level_path : String

@onready var introduction_level_container: GridContainer = $MarginContainer/BoxContainer/TabContainer/Introduction
@onready var testing_level_container: GridContainer = $MarginContainer/BoxContainer/TabContainer/Testing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	import_levels(indtroduction_level_path, introduction_level_container)
	import_levels(testing_level_path, testing_level_container)

func import_levels(levelPath : String , levelContainer : GridContainer) -> void:
	var paths = DirAccess.get_files_at(levelPath)
	for path in paths:
		var button = create_new_base_button()
		button.text = path.replace(".tscn","").replace("_"," ").to_upper()
		levelContainer.add_child(button)
		button.pressed.connect(func(): SceneController.goto_scene(levelPath + path))

func create_new_base_button() -> Button:
	var button = Button.new()
	button.custom_minimum_size = Vector2(200,100)
	return button

func _on_button_pressed() -> void:
	SceneController.goto_scene_no_loading_screen("res://menus/main_menu.tscn")
