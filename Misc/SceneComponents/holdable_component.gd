extends Node
class_name HoldableComponent

signal dropped
signal picked_up

func drop():
	dropped.emit()

func pick_up():
	picked_up.emit()
