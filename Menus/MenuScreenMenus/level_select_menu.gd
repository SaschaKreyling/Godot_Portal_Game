extends Control


@onready var introduction_level_container: GridContainer = $MarginContainer/BoxContainer/TabContainer/Introduction
@onready var testing_level_container: GridContainer = $MarginContainer/BoxContainer/TabContainer/Testing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	import_levels(PathConstants.LEVEL_DIRECTORY_PATH, introduction_level_container)
	import_levels(PathConstants.TEST_LEVEL_DIRECTORY_PATH, testing_level_container)

func import_levels(levelPath : String , levelContainer : GridContainer) -> void:
	var paths : PackedStringArray = DirAccess.get_files_at(levelPath)
	for path : String in paths:
		var button : Button = create_new_base_button()
		button.text = path.replace(".tscn", "").replace("_", " ").to_upper()
		levelContainer.add_child(button)
		button.pressed.connect(func(): SceneController.goto_scene(levelPath + path))

func create_new_base_button() -> Button:
	var button : Button = Button.new()
	button.custom_minimum_size = Vector2(200,100)
	return button

func _on_button_pressed() -> void:
	SceneController.goto_scene_no_loading_screen(PathConstants.MAIN_MENU_PATH)
