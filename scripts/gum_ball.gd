extends RigidBody3D
class_name GumBall

@onready var physicCollider: CollisionShape3D = $PhysicCollider
@onready var interactCollider: CollisionShape3D = $HitZone/InteractCollider
@onready var gumBallMesh: MeshInstance3D = $GumBallMesh
@onready var resetTimer : Timer = $ResetTimer

var startPosition : Vector3

var	isUsedAsGlue : bool = false
var gluedObject

var isPickedUp : bool = false
var isIdling : bool = true

func _ready() -> void:
	startPosition = global_position
	reset()

func reset() -> void:
	showAndEnable()
	setIdling()
	resetTimer.stop()
	gluedObject = null
	isUsedAsGlue = false

func _process(_delta: float) -> void:
	if(global_position != startPosition):
		cancelIdle()
	if isNotOnGround():
		resetTimer.start(5)

func togglePickedUp() -> void:
	isPickedUp = !isPickedUp

func isNotOnGround() -> bool:
	return isPickedUp or isUsedAsGlue or isPickedUp
	
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
	isIdling = true
	linear_velocity = Vector3(0,0,0)
	angular_velocity = Vector3(0,1,0)
	global_position = startPosition
	gravity_scale = 0

func cancelIdle() -> void:
	gravity_scale = 1
	isIdling = false

func onGlueableObjectHit(gluableObject) -> void:
	if gluableObject.setGlued(self):
		isUsedAsGlue = true
		gluedObject = gluableObject
		hideAndDisable()

func _on_hit_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("gluable"):
		onGlueableObjectHit(body)

func _on_timer_timeout() -> void:
	"reset"
	reset()
