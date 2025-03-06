extends RigidBody3D
class_name GumBall

@onready var interactCollider: CollisionShape3D = $InteractCollider
@onready var hitZoneCollider: CollisionShape3D = $HitZone/HitZoneCollider
@onready var gumBallMesh: MeshInstance3D = $GumBallMesh

var startPosition : Vector3
var inUse : bool = false
var gluedButton : FloorButton

func _ready() -> void:
	startPosition = global_position

func reset() -> void:
	gluedButton = null
	inUse = false
	interactCollider.disabled = false
	hitZoneCollider.disabled = false
	linear_velocity = Vector3(0,0,0)
	global_position = startPosition

func onButtonHit(button : FloorButton) -> void:
	inUse = true
	interactCollider.disabled = true
	hitZoneCollider.disabled = true
	gluedButton = button
	pass

func _on_hit_zone_body_entered(body: Node3D) -> void:
	reset()
