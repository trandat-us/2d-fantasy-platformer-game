extends KnightState

@export var ground_state: KnightState
@export var ledge_grab_state: KnightState

@export var ledge_grab_detector: RayCast2D
@export var ledge_grab_height_detector: RayCast2D

func enter():
	_enable_ledge_grab_detectors()
	animation_playback.travel("fall")

func exit():
	_disable_ledge_grab_detectors()

func state_physics_process(delta: float):
	if _can_grab():
		state_transition.emit(self, ledge_grab_state)
		return
	
	if knight.is_on_floor():
		state_transition.emit(self, ground_state)
		return
	
	movement_component.apply_gravity(delta)
	
	if knight.input_enabled:
		var axis = knight.check_horizontal_movement_input()
		if axis: 
			movement_component.move_x_axis(stats.walk_speed, axis)
	
	movement_component.move_and_slide()

func _enable_ledge_grab_detectors():
	ledge_grab_detector.enabled = true
	ledge_grab_height_detector.enabled = true

func _disable_ledge_grab_detectors():
	ledge_grab_detector.enabled = false
	ledge_grab_height_detector.enabled = false

func _can_grab() -> bool:
	var check_grab = ledge_grab_detector.is_colliding()
	var check_height = not ledge_grab_height_detector.is_colliding()
	var can_grab = check_grab and check_height and knight.is_on_wall_only()
	
	return can_grab
