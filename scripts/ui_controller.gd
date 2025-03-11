extends Node

@onready var pause_menu: Control = $PauseMenu
@onready var hud: CanvasLayer = $HUD

var paused: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		togglePauseMenu()

func togglePauseMenu():
	if paused:
		hud.show()
		pause_menu.hide()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		hud.hide()
		pause_menu.show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	paused = !paused
