extends CharacterBody3D

const SPEED = 6


@export var assigned_box : Box

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var path_finding_timer: Timer = $PathFindingTimer

@onready var holding_point: Node3D = $HoldingPoint


var state : State;

var target_direction_when_searching : Vector3 = Vector3()

enum State {
	GLUED,
	SEARCHING,
	PATROLING,
	FLOATING,
	HELD
}

func _ready() -> void:
	transition_to_state(State.SEARCHING)

func _process(delta: float) -> void:
	if Vector3(velocity.x,0,velocity.z).length() > 0:
		look_at(transform.origin + Vector3(velocity.x,0,velocity.z), Vector3.UP)

func _physics_process(delta: float) -> void:
	
	if not is_on_floor() and state != State.HELD:
		velocity += get_gravity() * delta
		
	if state == State.SEARCHING:
		if is_on_floor():
			var steering : Vector3 = target_direction_when_searching - velocity.normalized()
			velocity += steering * 2
			velocity = velocity.normalized() * SPEED
			
	if state == State.GLUED:
		if is_on_floor():
			velocity.x *= 0.95
			velocity.z *= 0.95
			
	if state == State.PATROLING:
		assigned_box.global_position = holding_point.global_position
		var steering : Vector3 = Vector3(2 * (randf() - 0.5), 0,2 * (randf() - 0.5)).normalized() - velocity.normalized()
		velocity += steering * 0.0001
		velocity = velocity.normalized() * SPEED
		
	move_and_slide()


func transition_to_state(new_state : State) -> void:
	if(new_state == state): return
	path_finding_timer.stop() 
	
	if(new_state == State.SEARCHING):
		target_direction_when_searching = direction_to_target() + 0.5 * Vector3(2 * (randf() - 0.5),0,2 * (randf() - 0.5)).normalized()
		target_direction_when_searching = target_direction_when_searching.normalized()
		path_finding_timer.start()
		
	state = new_state


func get_closest_navigatable_position(point : Vector3) -> Vector3:
	if NavigationServer3D.map_is_active(navigation_agent.get_navigation_map()):
		var nav_map = navigation_agent.get_navigation_map()
		return NavigationServer3D.map_get_closest_point(nav_map, point)
	return point

func direction_to_target() -> Vector3:
	navigation_agent.target_position = get_closest_navigatable_position(assigned_box.global_position)
	return global_position.direction_to(navigation_agent.get_next_path_position())

func _on_path_finding_timer_timeout() -> void:
	if state == State.SEARCHING: 
		target_direction_when_searching = direction_to_target() + 0.5 * Vector3(2 * (randf() - 0.5),0,2 * (randf() - 0.5)).normalized()
		target_direction_when_searching = target_direction_when_searching.normalized()

func _on_gluable_component_glued() -> void:
	transition_to_state(State.GLUED)

func _on_gluable_component_unglued() -> void:
	transition_to_state(State.SEARCHING)

func _on_holdable_component_dropped() -> void:
	transition_to_state(State.SEARCHING)

func _on_holdable_component_picked_up() -> void:
	transition_to_state(State.HELD)

func _on_pick_up_area_body_entered(body: Node3D) -> void:
	if state != State.GLUED or state != State.HELD:
		if body == assigned_box:
			transition_to_state(State.PATROLING)
