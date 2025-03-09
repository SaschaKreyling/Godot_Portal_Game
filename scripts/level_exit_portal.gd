extends StaticBody3D
class_name ExitPortal

@onready var player: Node3D = %Player
@onready var area_3d: Area3D = $Area3D
@onready var exitPortalLightMesh: MeshInstance3D = $ExitPortalLight
@onready var exitPortalLight1: SpotLight3D = $ExitPortalLight/ExitSpotLight3D
@onready var exitPortalLight2: SpotLight3D = $ExitPortalLight/ExitSpotLight3D2

var random : RandomNumberGenerator = RandomNumberGenerator.new()

func _process(_delta: float) -> void:
	checkForExit()
	var changeRandom : float = random.randf()
	if changeRandom < 0.1:
		var colorRandom : float = random.randf()
		if colorRandom < 0.5:
			setPortalLight(Color.YELLOW)
		elif colorRandom < 0.75:
			setPortalLight(Color.GREEN)
		else:
			setPortalLight(Color.RED) 

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
	SceneController.goto_scene_no_loading("res://menus/level_finished_screen.tscn")

func setPortalLight(color : Color) -> void:
	var material = StandardMaterial3D.new()
	material.emission_enabled = true
	material.emission = color
	material.albedo_color = color
	exitPortalLightMesh.mesh.surface_set_material(0,material)
	exitPortalLight1.light_color = color
	exitPortalLight2.light_color = color

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		playerInArea = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		playerInArea = false
		previousDot = null
