extends Node
class_name GluableComponent


@export var interaction_component : InteractionComponent

signal glued
signal unglued

var used_gum_ball : GumBall

func _ready() -> void:
	if interaction_component:
		interaction_component.interacted.connect(set_unglued)

func set_glued(gum_ball : GumBall) -> void:
	used_gum_ball = gum_ball
	glued.emit()

func set_unglued() -> void:
	if(used_gum_ball):
		used_gum_ball.reset()
		used_gum_ball = null
		unglued.emit()
