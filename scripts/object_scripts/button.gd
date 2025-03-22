extends StaticBody3D
class_name FloorButton

@onready var identfier : Identifier = $Identifier

@onready var button_mesh_instance: MeshInstance3D = $ButtonMesh
const BUTTON_DEACTIVATED_MESH : Mesh = preload("res://assets/button.obj")
const BUTTON_ACTIVATED_MESH : Mesh = preload("res://assets/button_activated.obj")
const BUTTON_GLUED_ACTIVATED_MESH : Mesh = preload("res://assets/button_glued.obj")
const BUTTON_GLUED_DEACTIVATED_MESH : Mesh = preload("res://assets/button_glued_deactivated.obj")


@onready var on_activation_streamer: AudioStreamPlayer3D = $OnActivartionStreamer
const ACTIVATION_SOUND : AudioStream = preload("res://assets/button-click-289742.mp3")
const DEACTIVATION_SOUND : AudioStream = preload("res://assets/button-click-289742 (mp3cut.net).mp3")
const SQUISH_SOUND : AudioStream = preload("res://assets/gooey-squish-14820.mp3")

var link_color : Color

var current_activators : Array = []
var state : ButtonState = ButtonState.DEACTIVATED

func _ready() -> void:
	update_state()

func set_activated() -> void:
	if(state != ButtonState.ACTIVATED):
		state = ButtonState.ACTIVATED
		button_mesh_instance.mesh = BUTTON_ACTIVATED_MESH
		on_activation_streamer.stream = ACTIVATION_SOUND 
		on_activation_streamer.play()

func set_deactivated() -> void:
	if(state != ButtonState.DEACTIVATED):
		state = ButtonState.DEACTIVATED
		button_mesh_instance.mesh = BUTTON_DEACTIVATED_MESH
		on_activation_streamer.stream = DEACTIVATION_SOUND
		on_activation_streamer.play()

func set_glued():
	if state == ButtonState.ACTIVATED:
		state = ButtonState.GLUED_ACTIVATED
		button_mesh_instance.mesh = BUTTON_GLUED_ACTIVATED_MESH
	elif state == ButtonState.DEACTIVATED:
		state = ButtonState.GLUED_DEACTIVATED
		button_mesh_instance.mesh = BUTTON_GLUED_DEACTIVATED_MESH
		
	on_activation_streamer.stream = SQUISH_SOUND
	on_activation_streamer.play()

func set_unglued() -> void:
	state = ButtonState.UNKNOWN
	on_activation_streamer.stream = SQUISH_SOUND
	on_activation_streamer.play()
	update_state()

func update_state():
	if not is_glued():
		if not current_activators.is_empty():
			set_activated()
		else:
			set_deactivated()

func is_glued() -> bool:
	return state == ButtonState.GLUED_ACTIVATED or state == ButtonState.GLUED_DEACTIVATED
	
func is_activated() -> bool:
	if state == ButtonState.UNKNOWN:
		update_state()
	return state == ButtonState.GLUED_ACTIVATED or state == ButtonState.ACTIVATED

func _on_activation_area_body_entered(body: Node3D) -> void:
	if(body.is_in_group("presser")):
		current_activators.append(body)
		update_state()

func _on_activation_area_body_exited(body: Node3D) -> void:
	if(body.is_in_group("presser")):
		current_activators.erase(body)
		update_state()

func set_link_color(color : Color) -> void:
	link_color = color
	identfier.update_color(link_color)

func _on_gluable_component_glued() -> void:
	set_glued()

func _on_gluable_component_unglued() -> void:
	set_unglued()

enum ButtonState {
	DEACTIVATED,
	ACTIVATED,
	GLUED_ACTIVATED,
	GLUED_DEACTIVATED,
	UNKNOWN
}
