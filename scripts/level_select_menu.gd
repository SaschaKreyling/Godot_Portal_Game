extends Control

@export var indtroductionLevelPath : String
@export var testingLevelPath : String

@onready var introductionContainer: GridContainer = $MarginContainer/TabContainer/Introduction
@onready var testingContainer: GridContainer = $MarginContainer/TabContainer/Testing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	importLevels(indtroductionLevelPath, introductionContainer)
	importLevels(testingLevelPath, testingContainer)

func importLevels(levelPath : String , levelContainer : GridContainer) -> void:
	var paths = DirAccess.get_files_at(levelPath)
	for path in paths:
		var button = createNewButton()
		button.text = path.replace(".tscn","").replace("_"," ").to_upper()
		levelContainer.add_child(button)
		button.pressed.connect(func(): SceneController.goto_scene(levelPath + path))

func createNewButton() -> Button:
	var button = Button.new()
	button.custom_minimum_size = Vector2(200,100)
	return button
