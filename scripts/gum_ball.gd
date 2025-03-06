extends RigidBody3D
class_name GumBall

@onready var interactCollider: CollisionShape3D = $InteractCollider
@onready var hitZoneCollider: CollisionShape3D = $HitZone/HitZoneCollider
@onready var gumBallMesh: MeshInstance3D = $GumBallMesh
@onready var hitZone: Area3D = $HitZone

var startPosition : Vector3
var inUse : bool = false
var gluedObject

func _ready() -> void:
	startPosition = global_position

func reset() -> void:
	gluedObject = null
	inUse = false
	gumBallMesh.visible = true
	interactCollider.set_deferred("disabled", false) 
	hitZoneCollider.set_deferred("disabled", false) 
	linear_velocity = Vector3(0,0,0)
	global_position = startPosition

func onGlueableObjectHit(gluableObject) -> void:
	if gluableObject.setGlued(self):
		inUse = true
		interactCollider.set_deferred("disabled", true) 
		hitZoneCollider.set_deferred("disabled", true) 
		gluedObject = gluableObject
		gumBallMesh.visible = false
	else:
		reset()

func _on_hit_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("gluable"):
		onGlueableObjectHit(body)
	else:
		reset()
