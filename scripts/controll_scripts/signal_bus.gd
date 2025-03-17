extends Node

signal teleported_object(object : Node3D, destination : Portal)

func signal_teleport(object : Node3D, destination : Portal) -> void:
	teleported_object.emit(object, destination)
