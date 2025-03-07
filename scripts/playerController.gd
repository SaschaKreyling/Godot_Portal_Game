class_name Player extends CharacterBody3D

@export_category("PlayerOptions")
@export var SPEED : float = 5
@export var JUMP_VELOCITY : float = 5.3

@onready var camera: Camera3D = $Camera3D

@onready var pause_menu: Control = $Camera3D/pause_menu
var paused = false
var gravity_normal = 1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * 0.001 * gravity_normal)
		camera.rotate_x(-event.relative.y * 0.001)
		camera.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta: float) -> void:
	move_and_slide()

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("Up") and is_on_floor() :
		velocity.y = JUMP_VELOCITY
		
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
		pauseMenu()

#pauseMenu stops time and shows menu on pause, reverse on resume
func pauseMenu():
	if paused:
		pause_menu.hide()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		pause_menu.show()
		get_tree().paused = true
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	paused = !paused




func _on_gravity_gravity_turned(gravity: int) -> void:
	gravity_normal = gravity
