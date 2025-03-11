class_name Player extends CharacterBody3D

@export_category("PlayerOptions")
@export var SPEED : float = 5
@export var JUMP_VELOCITY : float = 5.3
@export var ROTATION_SPEED : float = 0.05

@onready var camera: Camera3D = $Camera3D

@onready var ui: Node = $Camera3D/UI

var paused = false
var turning = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate(global_basis.y, -event.relative.x * 0.001)
		camera.rotate_x(-event.relative.y * 0.001)
		camera.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(_delta: float) -> void:
	move_and_slide()

var gravityTurned = false

func _process(delta) -> void:
	if updateUpDirection():
		gravityTurned = true

	turnToGravity()
	handleMovement(delta)
	
func handleMovement(delta):
	var localVelocity = global_basis.inverse() * velocity
	if !gravityTurned:
		if Input.is_action_just_pressed("Up") and is_on_floor() :
			localVelocity.y = JUMP_VELOCITY 
			
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
		var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			localVelocity.x = direction.x * SPEED
			localVelocity.z = direction.z * SPEED
		else:
			localVelocity.x = move_toward(velocity.x, 0, SPEED)
			localVelocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		localVelocity.x = 0
		localVelocity.z = 0
		
	if not is_on_floor():
		localVelocity.y += -get_gravity().length() * delta
	elif gravityTurned and not turning:
			gravityTurned = false 
		
	velocity = global_basis * localVelocity

func updateUpDirection() -> bool:
	var newUp = -get_gravity().normalized()
	var changed = up_direction != newUp
	up_direction = newUp
	return changed
	
func turnToGravity() -> void:
	var targetUp = up_direction
	var currentUp = global_basis.y
	
	var angle : float = min(ROTATION_SPEED, acos(currentUp.dot(up_direction)))
	if angle != 0:
		turning = true
		var ortho = currentUp.cross(targetUp).normalized()
		var axis = ortho if ortho.length() > 0 else global_basis.z
		rotate(axis , angle)
	else:
		turning = false
