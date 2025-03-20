extends Node
class_name HoldableShapeComponent

signal dropped
signal picked_up

func drop():
	dropped.emit()

func pick_up():
	picked_up.emit()
