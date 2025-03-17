extends Node3D
class_name Portal

@export_category("PortalSettings")
@export var linkedPortal: Portal
@export var buttons: Array[FloorButton]

@onready var player: Node3D = %Player
@onready var playerCamera: Camera3D = %Player/Camera3D

@onready var portalCamera: Camera3D = $PortalViewport/PortalCamera
@onready var ancors : Array = $AncorPoints.get_children()
@onready var portalSurface: MeshInstance3D = $PortalSurface/PortalSurfaceMesh
@onready var portalViewport: Viewport = $PortalViewport
@onready var portalCollider: CollisionShape3D = $PortalSurface/PortalCollider

@onready var alternateInteractRayCast: RayCast3D = $PortalViewport /PortalCamera/AlternateInteractRayCast
@onready var alternateholdingAncor: Node3D = $PortalViewport/PortalCamera/AlternateHoldingAncor

@onready var identfier : Identifier = $Identifier

@onready var portalLightMesh: MeshInstance3D = $PortalLight
@onready var portalSpotLight1: SpotLight3D = $PortalLight/SpotLight3D
@onready var portalSpotLight2: SpotLight3D = $PortalLight/SpotLight3D2

var activated : bool = true
var activeLampColor: Color  = Color.GREEN
var deactiveLampColor: Color = Color.RED

var linkColor: Color

var bodiesToCheck : Array[Node3D]
var previousDots : Dictionary


func _ready() -> void:
	playerCamera.get_viewport().connect("size_changed", _on_viewport_resize)
	_on_viewport_resize()
	set_lamp_color(activeLampColor)
	
func setLinkColor(color : Color) -> void:
	linkColor = color
	identfier.updateColor(linkColor)

func _on_viewport_resize() -> void:
	portalViewport.size = playerCamera.get_viewport().size * SettingsManager.portal_quality

func _process(_delta: float) -> void:
	if are_all_buttons_activated() and not activated:
		set_activated()
	elif not activated:
		set_deactivated()
	
	if both_portals_activated():
		portalSurface.visible = true
		update_portal_camera()
		checkForTeleport()
	else:
		portalSurface.visible = false

func set_activated():
	activated = true
	portalCollider.disabled = false
	set_lamp_color(activeLampColor)
	portalViewport.render_target_update_mode = portalViewport.UPDATE_ALWAYS
	
func set_deactivated():
	activated = false
	portalCollider.disabled = true
	set_lamp_color(deactiveLampColor)
	portalViewport.render_target_update_mode = portalViewport.UPDATE_DISABLED

func set_lamp_color(color : Color) -> void:
	var material : StandardMaterial3D =  StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	portalLightMesh.set_surface_override_material(0 , material)
	portalSpotLight1.light_color = color
	portalSpotLight2.light_color = color

func checkForTeleport() -> void:
	for bodyToCheck in bodiesToCheck:
		var direction_to_portal : Vector3 = bodyToCheck.global_position - global_position
		var dot_product_portal_normal : float = direction_to_portal.dot(global_basis.z)
		var hasCrossedPortal : bool = previousDots.has(bodyToCheck) and sign(dot_product_portal_normal) != sign(float(previousDots.get(bodyToCheck)))
		if hasCrossedPortal:
			stop_checking_body(bodyToCheck)
			teleport(bodyToCheck)
		previousDots.erase(bodyToCheck)
		previousDots.get_or_add(bodyToCheck, dot_product_portal_normal)

func update_portal_camera() -> void:
	portalCamera.position = linkedPortal.to_global(to_local(playerCamera.global_position)*(Vector3(-1,1,-1)))
	
	var relative_rotation_to_portal : Basis  = global_transform.basis.inverse() * playerCamera.global_transform.basis
	portalCamera.rotation = (linkedPortal.global_transform.basis * relative_rotation_to_portal.scaled(Vector3(-1,1,-1))).get_euler()	
	
	var cameraNormal : Vector3 = portalCamera.global_basis.z
	
	var smallestDst : float = portalCamera.far
	for ancor : Node3D in linkedPortal.ancors:
		var dst : float = (ancor.global_position - portalCamera.global_position).dot(cameraNormal) / cameraNormal.length()
		smallestDst = min(smallestDst, abs(dst))
	portalCamera.near = max(0.25, smallestDst)

func teleport(body : Node3D) -> void:
	set_relative_position(body)
	set_relative_rotation(body)
	set_relative_velocity(body)
	SignalBus.signal_teleport(body, linkedPortal)

func set_relative_position(body : Node3D) -> void:
	var newPosition : Vector3 = linkedPortal.to_global(to_local(body.global_position)*Vector3(-1,1,-1))
	body.global_position = newPosition

func set_relative_rotation(body : Node3D) -> void:
	var relative_rotation_to_portal : Basis = global_transform.basis.inverse() * body.global_transform.basis
	body.global_rotation = (linkedPortal.global_transform.basis * relative_rotation_to_portal.scaled(Vector3(-1,1,-1))).get_euler()

func set_relative_velocity(body : Node3D) -> void:
	if body is Player:
		var vel_in : Vector3 = body.velocity 
		var vel_out = calculate_relative_velocity(vel_in)
		body.velocity = vel_out
	elif body is RigidBody3D:
		var vel_in = body.linear_velocity
		var vel_out = calculate_relative_velocity(vel_in)
		body.set_linear_velocity(vel_out)

func calculate_relative_velocity(vel_in : Vector3) -> Vector3:
	var portal_x : Vector3 = basis.x
	var portal_y : Vector3 = basis.y
	var portal_z : Vector3 = basis.z
		
	var linkPortal_x = -linkedPortal.basis.x
	var linkPortal_y = linkedPortal.basis.y
	var linkPortal_z = -linkedPortal.basis.z
		
	var vel_parallel_out_x = (vel_in.dot(portal_x)) * linkPortal_x
	var vel_parallel_out_y = (vel_in.dot(portal_y)) * linkPortal_y
	var vel_parallel_out_z = (vel_in.dot(portal_z)) * linkPortal_z
	var vel_out = vel_parallel_out_x + vel_parallel_out_y + vel_parallel_out_z
	return vel_out

func are_all_buttons_activated() -> bool:
	var active : bool = true
	for button in buttons:
		active = active and button.activated
	return active
	
func both_portals_activated() -> bool:
	return activated and linkedPortal.activated 

func stop_checking_body(body : Node3D) -> void:
	bodiesToCheck.erase(body)
	previousDots.erase(body)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("portable"):
		bodiesToCheck.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	stop_checking_body(body)
