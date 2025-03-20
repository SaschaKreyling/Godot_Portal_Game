class_name Player extends CharacterBody3D

@export_category("PlayerOptions")
@export var SPEED : float = 5
@export var JUMP_VELOCITY : float = 5.3
@export var ROTATION_SPEED : float = 0.05

@onready var camera: Camera3D = $Camera3D

@onready var ui: Node = $Camera3D/UI

var was_gravity_turned = false
var paused = false
var turning = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate(global_basis.y.normalized(), -event.relative.x * 0.001)
		camera.rotate_x(-event.relative.y * 0.001)
		camera.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta: float) -> void:
	if update_up_direction():
		was_gravity_turned = true
		
	turn_to_gravity()
	handle_movement(delta)
	move_and_slide()

func handle_movement(delta):
	var local_velocity = global_basis.inverse() * velocity
	if !was_gravity_turned:
		if Input.is_action_just_pressed("Up") and is_on_floor() :
			local_velocity.y = JUMP_VELOCITY 
			
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
		var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			local_velocity.x = direction.x * SPEED
			local_velocity.z = direction.z * SPEED
		else:
			local_velocity.x = move_toward(velocity.x, 0, SPEED)
			local_velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		local_velocity.x = 0
		local_velocity.z = 0
		
	if not is_on_floor():
		local_velocity.y += -get_gravity().length() * delta
	elif was_gravity_turned and not turning:
			was_gravity_turned = false 
		
	velocity = global_basis * local_velocity

func update_up_direction() -> bool:
	var new_up_direction = -get_gravity().normalized()
	var changed = up_direction != new_up_direction
	if new_up_direction:
		up_direction = new_up_direction
	return changed

func turn_to_gravity() -> void:
	var target_up_direction = up_direction
	var current_player_up_direction = global_basis.y
	
	var angle : float = min(ROTATION_SPEED, acos(current_player_up_direction.dot(target_up_direction)))
	if angle != 0:
		turning = true
		var ortho = current_player_up_direction.cross(target_up_direction).normalized()
		var axis = ortho if ortho.length() > 0 else global_basis.z
		rotate(axis , angle)
	else:
		turning = false
