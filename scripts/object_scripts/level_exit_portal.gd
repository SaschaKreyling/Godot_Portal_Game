extends StaticBody3D
class_name ExitPortal

@onready var player: Node3D = %Player
@onready var exit_portal_light_mesh_instance: MeshInstance3D = $ExitPortalLight
@onready var exit_portal_light_one: SpotLight3D = $ExitPortalLight/ExitSpotLight3D
@onready var exit_portal_light_two: SpotLight3D = $ExitPortalLight/ExitSpotLight3D2

var is_player_in_area: bool
var previous_dot_product

func _process(_delta: float) -> void:
	check_for_exit()
	flicker_lights()

func flicker_lights() -> void:
	var flicker_value : float = randf()
	if flicker_value < 0.1:
		var color_value : float = randf()
		if color_value < 0.5:
			set_portal_light_color(Color.YELLOW)
		elif color_value < 0.75:
			set_portal_light_color(Color.GREEN)
		else:
			set_portal_light_color(Color.RED) 

func check_for_exit() -> void:
	if is_player_in_area:
		var relativePosition : Vector3 = player.global_position - global_position
		var dot_product: float = relativePosition.dot(global_basis.z)
		var hasCrossedPortal : bool = previous_dot_product != null and sign(dot_product) != sign(previous_dot_product)
		if hasCrossedPortal:
			exit_level()
			pass
		previous_dot_product = dot_product

func exit_level() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SceneController.goto_scene("res://menus/level_finished_screen.tscn")

func set_portal_light_color(color : Color) -> void:
	var material = StandardMaterial3D.new()
	material.emission_enabled = true
	material.emission = color
	material.albedo_color = color
	exit_portal_light_mesh_instance.mesh.surface_set_material(0,material)
	exit_portal_light_one.light_color = color
	exit_portal_light_two.light_color = color

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		is_player_in_area = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		is_player_in_area = false
		previous_dot_product = null
