extends StaticBody3D
class_name ExitPortal

@onready var player: Node3D = %Player
@onready var area_3d: Area3D = $Area3D

func _process(delta: float) -> void:
	checkForExit()

var playerInArea: bool
var previousDot 
func checkForExit() -> void:
	if playerInArea:
		var relativePosition : Vector3 = player.global_position - global_position
		var dot : float = relativePosition.dot(global_basis.z)
		var hasCrossedPortal : bool = previousDot != null and sign(dot) != sign(previousDot)
		if hasCrossedPortal:
			exitLevel()
			pass
		previousDot = dot

func exitLevel():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		playerInArea = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		playerInArea = false
		previousDot = null
