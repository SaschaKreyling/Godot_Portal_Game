extends Node3D

@export_color_no_alpha var link_color : Color

func _ready() -> void:
	var children : Array = get_children()
	for child : Object in children:
		if child.has_method("set_link_color"):
			child.set_link_color(link_color)
