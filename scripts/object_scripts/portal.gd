extends Node3D
class_name Portal

@export_category("PortalSettings")
@export var linked_portal: Portal
@export var buttons: Array[FloorButton]

@onready var player: Node3D = %Player
@onready var player_camera: Camera3D = %Player/Camera3D

@onready var portal_camera: Camera3D = $PortalViewport/PortalCamera
@onready var ancors : Array = $AncorPoints.get_children()
@onready var portal_surface_mesh_instance: MeshInstance3D = $PortalSurface/PortalSurfaceMesh
@onready var portal_camera_target_viewport: Viewport = $PortalViewport
@onready var portal_surface_collider: CollisionShape3D = $PortalSurface/PortalCollider

@onready var alternate_interact_ray_cast: RayCast3D = $PortalViewport /PortalCamera/AlternateInteractRayCast
@onready var alternate_holding_ancor: Node3D = $PortalViewport/PortalCamera/AlternateHoldingAncor

@onready var identfier : Identifier = $Identifier

@onready var portal_light_mesh_instance: MeshInstance3D = $PortalLight
@onready var portal_spot_light_one: SpotLight3D = $PortalLight/SpotLight3D
@onready var portal_spot_light_two: SpotLight3D = $PortalLight/SpotLight3D2

@onready var navigation_link: NavigationLink3D = $NavigationLink3D

var activated : bool
var active_lamp_color: Color  = Color.GREEN
var deactive_lamp_color: Color = Color.RED

var link_color: Color

var portable_bodies_in_area : Array[Node3D]
var previous_dot_products : Dictionary

func _ready() -> void:
	navigation_link.set_global_end_position(linked_portal.global_position)
	player_camera.get_viewport().size_changed.connect(_on_viewport_resize)
	SettingsManager.portal_quality_updated.connect(_on_viewport_resize)
	_on_viewport_resize()
	set_deactivated()

func _physics_process(_delta: float) -> void:
	if both_portals_activated():
		check_for_cross_and_teleport()

func _process(_delta: float) -> void:
	if are_all_buttons_activated() and not activated:
		set_activated()
	elif not are_all_buttons_activated():
		set_deactivated()

	if both_portals_activated():
		portal_surface_mesh_instance.visible = true
		update_portal_camera()
	else:
		portal_surface_mesh_instance.visible = false

func set_activated() -> void:
	activated = true
	navigation_link.enabled = true
	portal_surface_collider.disabled = false
	set_lamp_color(active_lamp_color)
	portal_camera_target_viewport.render_target_update_mode = portal_camera_target_viewport.UPDATE_ALWAYS
	
func set_deactivated() -> void:
	activated = false
	navigation_link.enabled = false
	portal_surface_collider.disabled = true
	set_lamp_color(deactive_lamp_color)
	portal_camera_target_viewport.render_target_update_mode = portal_camera_target_viewport.UPDATE_DISABLED

func set_lamp_color(color : Color) -> void:
	var material : StandardMaterial3D =  StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	portal_light_mesh_instance.set_surface_override_material(0 , material)
	portal_spot_light_one.light_color = color
	portal_spot_light_two.light_color = color

func check_for_cross_and_teleport() -> void:
	for portable_body in portable_bodies_in_area:
		var direction_to_portal : Vector3 = portable_body.global_position - global_position
		var dot_product_portal_normal : float = direction_to_portal.dot(global_basis.z)
		var body_has_crossed_portal : bool = previous_dot_products.has(portable_body) and sign(dot_product_portal_normal) != sign(float(previous_dot_products.get(portable_body)))
		if body_has_crossed_portal:
			stop_checking_body(portable_body)
			teleport(portable_body)
		previous_dot_products.erase(portable_body)
		previous_dot_products.get_or_add(portable_body, dot_product_portal_normal)

func update_portal_camera() -> void:
	portal_camera.position = linked_portal.to_global(to_local(player_camera.global_position))
	
	var relative_rotation_to_portal : Basis  = global_transform.basis.inverse() * player_camera.global_transform.basis
	portal_camera.rotation = (linked_portal.global_transform.basis * relative_rotation_to_portal).get_euler()	
	
	var cameraNormal : Vector3 = portal_camera.global_basis.z
	
	var smallestDst : float = portal_camera.far
	for ancor : Node3D in linked_portal.ancors:
		var dst : float = (ancor.global_position - portal_camera.global_position).dot(cameraNormal) / cameraNormal.length()
		smallestDst = min(smallestDst, abs(dst))
	portal_camera.near = max(0.25, smallestDst)

func teleport(body : Node3D) -> void:
	set_relative_rotation(body)
	set_relative_position(body)
	set_relative_velocity(body)
	SignalBus.signal_teleport(body, linked_portal)

func set_relative_position(body : Node3D) -> void:
	var newPosition : Vector3 = linked_portal.to_global(to_local(body.global_position))
	body.global_position = newPosition

func set_relative_rotation(body : Node3D) -> void:
	var relative_rotation_to_portal : Basis = global_transform.basis.inverse() * body.global_transform.basis
	body.global_rotation = (linked_portal.global_transform.basis * relative_rotation_to_portal).get_euler()

func set_relative_velocity(body : Node3D) -> void:
	if body is CharacterBody3D:
		var velocity_in : Vector3 = body.velocity 
		var velocity_out = calculate_relative_velocity(velocity_in)
		body.velocity = velocity_out
	elif body is RigidBody3D:
		var velocity_in = body.linear_velocity
		var velocity_out = calculate_relative_velocity(velocity_in)
		body.set_linear_velocity(velocity_out)

func calculate_relative_velocity(velocity_in : Vector3) -> Vector3:	
	var velocity_local = global_basis.inverse() * velocity_in
	var velocity_out = linked_portal.global_basis * velocity_local
	return velocity_out

func are_all_buttons_activated() -> bool:
	var active : bool = true
	for button in buttons:
		active = active and button.is_activated()
	return active

func both_portals_activated() -> bool:
	return activated and linked_portal.activated 

func stop_checking_body(body : Node3D) -> void:
	portable_bodies_in_area.erase(body)
	previous_dot_products.erase(body)

func _on_viewport_resize() -> void:
	portal_camera_target_viewport.size = player_camera.get_viewport().size * SettingsManager.get_portal_quality_scale()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("portable"):
		portable_bodies_in_area.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	stop_checking_body(body)

func set_link_color(color : Color) -> void:
	link_color = color
	identfier.update_color(link_color)
