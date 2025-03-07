extends Node

@onready var pause_menu: Control = $PauseMenu

var paused: bool = false

func togglePauseMenu():
	if paused:
		pause_menu.hide()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		pause_menu.show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	paused = !paused
