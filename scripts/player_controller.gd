class_name Player extends CharacterBody3D

@export_category("PlayerOptions")
@export var SPEED : float = 5
@export var JUMP_VELOCITY : float = 5.3

@onready var camera: Camera3D = $Camera3D

@onready var ui: Node = $Camera3D/UI

var paused = false
var gravity_normal = 1
var gravity_switched = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate(Vector3.UP,-event.relative.x * 0.001 * gravity_normal)
		camera.rotate_x(-event.relative.y * 0.001)
		camera.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _process(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if gravity_normal == -1 and not gravity_switched:
		velocity += get_gravity() * delta
		gravity_switched = true
		up_direction = Vector3(0, -1, 0)
	
	if gravity_normal == 1:
		gravity_switched = false
		up_direction = Vector3(0, 1, 0)
	
	if Input.is_action_just_pressed("Up") and is_on_floor() :
		velocity.y = JUMP_VELOCITY * gravity_normal
		
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	#Check for pause input
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		ui.togglePauseMenu()

func _on_gravity_gravity_turned(gravity: int) -> void:
	gravity_normal = gravity
