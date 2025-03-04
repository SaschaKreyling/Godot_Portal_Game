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


var isBodyinsideArea : bool = false
var bodyToTeleport : Node3D

func _ready() -> void:
	playerCamera.get_viewport().connect("size_changed", _on_viewport_resize)
	_on_viewport_resize()
	identfier.color = linkColor

func _on_viewport_resize() -> void:
	$PortalViewport.size = playerCamera.get_viewport().size 

func _process(delta: float) -> void:
	portalSurface.visible = activated
	if(!buttons.is_empty()):
		activated = true
		for button in buttons:
			activated = activated and button.activated
	if activated and linkedPortal.activated:
		portalSurface.visible = true
		setPortalCameraPositionAndRotation()
		checkForTeleport()
	else:
		portalSurface.visible = false

var previousDot 
func _physics_process(delta: float) -> void:
	return
		#if isBodyinsideArea:
		#var relativePosition : Vector3 = bodyToTeleport.global_position - global_position
		#previousDot = relativePosition.dot(global_basis.z)
	

func checkForTeleport() -> void:
	if isBodyinsideArea:
		var relativePosition : Vector3 = bodyToTeleport.global_position - global_position
		var dot : float = relativePosition.dot(global_basis.z)
		var hasCrossedPortal : bool = previousDot != null and sign(dot) != sign(previousDot)
		if hasCrossedPortal:
			teleport(bodyToTeleport)
			pass
		previousDot = dot
	

func setPortalCameraPositionAndRotation() -> void:
	portalCamera.position = linkedPortal.to_global(to_local(playerCamera.global_position)*(Vector3(-1,1,-1)))
	
	var relative_rotation_to_portal : Basis  = global_transform.basis.inverse() * playerCamera.global_transform.basis
	portalCamera.rotation = (linkedPortal.global_transform.basis * relative_rotation_to_portal.scaled(Vector3(-1,1,-1))).get_euler()	
	
	var cameraNormal : Vector3 = portalCamera.global_basis.z
	
	var smallestDst : float = portalCamera.far
	for ancor : Node3D in linkedPortal.ancors:
		var dst : float = abs((ancor.global_position - portalCamera.global_position).dot(cameraNormal) / cameraNormal.length())
		smallestDst = min(smallestDst, dst)
	portalCamera.near = max(0.25, smallestDst)

func teleport(body : Node3D) -> void:
	var newPosition : Vector3 = linkedPortal.to_global(to_local(body.global_position)*Vector3(-1,1,-1))
	#var portalNormal : Vector3  = -linkedPortal.global_basis.z
	#newPosition = newPosition + 2 * (portalNormal.dot(linkedPortal.global_position - newPosition)/(portalNormal.dot(portalNormal))) * (portalNormal)
	body.global_position = newPosition
	var relative_rotation_to_portal : Basis = global_transform.basis.inverse() * body.global_transform.basis
	body.global_rotation = (linkedPortal.global_transform.basis * relative_rotation_to_portal.scaled(Vector3(-1,1,-1))).get_euler()
	resetCheck()

func resetCheck() -> void:
	bodyToTeleport = null
	isBodyinsideArea = false
	previousDot = null

func _on_area_3d_body_entered(body: Node3D) -> void:
	bodyToTeleport = body
	isBodyinsideArea = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	resetCheck()
