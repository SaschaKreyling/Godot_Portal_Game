extends Node
class_name InteractionComponent

signal interacted

func interact():
	interacted.emit()
