extends Node3D
class_name Portal

@export_category("PortalSettings")
@export var linkedPortal: Portal
@export_color_no_alpha var linkColor: Color
@export var buttons: Array[FloorButton]
@export var activated : bool = true

@onready var player: Node3D = %Player
@onready var playerCamera: Camera3D = %Player/Camera3D

@onready var portalCamera: Camera3D = $PortalViewport/PortalCamera
@onready var ancors : Array = $AncorPoints.get_children()
@onready var portalSurface: MeshInstance3D = $PortalSurface
@onready var portalLight: MeshInstance3D = $PortalLight

@onready var identfier : Identifier = $Identifier


var bodiesToTeleport : Array[Node3D]
var previousDots : Dictionary

func _ready() -> void:
	playerCamera.get_viewport().connect("size_changed", _on_viewport_resize)
	_on_viewport_resize()
	identfier.updateColor(linkColor)

func _on_viewport_resize() -> void:
	$PortalViewport.size = playerCamera.get_viewport().size * 0.3

func _process(delta: float) -> void:
	activated = areAllButtonsActive()
	portalSurface.visible = shouldBeVisibleAndChecking()
	if shouldBeVisibleAndChecking():
		setPortalCameraPositionAndRotation()
		checkForTeleport()


func checkForTeleport() -> void:
	for bodyToTeleport in bodiesToTeleport:
		var relativePosition : Vector3 = bodyToTeleport.global_position - global_position
		var dot : float = relativePosition.dot(global_basis.z)
		var hasCrossedPortal : bool = previousDots.has(bodyToTeleport) and sign(dot) != sign(float(previousDots.get(bodyToTeleport)))
		if hasCrossedPortal:
			teleport(bodyToTeleport)
			pass
		previousDots.erase(bodyToTeleport)
		previousDots.get_or_add(bodyToTeleport, dot)

func setPortalCameraPositionAndRotation() -> void:
	portalCamera.position = linkedPortal.to_global(to_local(playerCamera.global_position)*(Vector3(-1,1,-1)))
	
	var relative_rotation_to_portal : Basis  = global_transform.basis.inverse() * playerCamera.global_transform.basis
	portalCamera.rotation = (linkedPortal.global_transform.basis * relative_rotation_to_portal.scaled(Vector3(-1,1,-1))).get_euler()	
	
	var cameraNormal : Vector3 = portalCamera.global_basis.z
	
	var smallestDst : float = portalCamera.far
	for ancor : Node3D in linkedPortal.ancors:
		var dst : float = (ancor.global_position - portalCamera.global_position).dot(cameraNormal) / cameraNormal.length()
		smallestDst = min(smallestDst, abs(dst))
	portalCamera.near = max(0.5, smallestDst)

func teleport(body : Node3D) -> void:
	var newPosition : Vector3 = linkedPortal.to_global(to_local(body.global_position)*Vector3(-1,1,-1))
	body.global_position = newPosition
	var relative_rotation_to_portal : Basis = global_transform.basis.inverse() * body.global_transform.basis
	body.global_rotation = (linkedPortal.global_transform.basis * relative_rotation_to_portal.scaled(Vector3(-1,1,-1))).get_euler()
	removeBody(body)

func areAllButtonsActive() -> bool:
	var active : bool = true
	for button in buttons:
		active = active and button.activated
	return active
	
func shouldBeVisibleAndChecking() -> bool:
	return activated and linkedPortal.activated

func removeBody(body : Node3D) -> void:
	if body.is_in_group("portable"):
		bodiesToTeleport.erase(body)
		previousDots.erase(body)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("portable"):
		bodiesToTeleport.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	removeBody(body)
