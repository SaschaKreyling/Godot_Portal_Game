extends RigidBody3D
class_name GumBall

@onready var physicCollider: CollisionShape3D = $PhysicCollider
@onready var interactCollider: CollisionShape3D = $HitZone/InteractCollider
@onready var gumBallMesh: MeshInstance3D = $GumBallMesh
@onready var resetTimer : Timer = $ResetTimer

var startPosition : Vector3

var inUse : bool = false
var gluedObject

var pickedUp : bool = false

var idle : bool = true

func _ready() -> void:
	startPosition = global_position
	reset()

func reset() -> void:
	showAndEnable()
	setIdling()
	resetTimer.stop()
	gluedObject = null
	inUse = false

func _process(_delta: float) -> void:
	if(global_position != startPosition):
		cancelIdle()
	if isNotOnGround():
		resetTimer.start(5)

func togglePickedUp() -> void:
	pickedUp = !pickedUp

func isNotOnGround() -> bool:
	return pickedUp or inUse or idle
	
func hideAndDisable() -> void:
	physicCollider.set_deferred("disabled", true) 
	interactCollider.set_deferred("disabled", true) 
	global_position = Vector3(-1000,-1000,-1000)
	linear_velocity = Vector3(0,0,0)
	gumBallMesh.visible = false

func showAndEnable() -> void:
	gumBallMesh.visible = true
	physicCollider.set_deferred("disabled", false) 
	interactCollider.set_deferred("disabled", false) 

func setIdling() -> void:
	idle = true
	linear_velocity = Vector3(0,0,0)
	angular_velocity = Vector3(0,1,0)
	global_position = startPosition
	gravity_scale = 0

func cancelIdle() -> void:
	gravity_scale = 1
	idle = false

func onGlueableObjectHit(gluableObject) -> void:
	if gluableObject.setGlued(self):
		inUse = true
		gluedObject = gluableObject
		hideAndDisable()
	else:
		reset()

func _on_hit_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("gluable"):
		onGlueableObjectHit(body)

func _on_timer_timeout() -> void:
	"reset"
	reset()
