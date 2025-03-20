extends Node
class_name InteractionColliderComponent

signal interacted

func interact():
	interacted.emit()
