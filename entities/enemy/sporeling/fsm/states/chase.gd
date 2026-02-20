extends SporelingState

@export var idle_state: SporelingState
@export var attack_state: SporelingState

@export var vision_area: VisionArea
@export var floor_detector: RayCast2D

var _y_speed_multiplier: float = 0.7
var _chase_speed_multiplier: float = 1.5
var _attack_range: float = 5.0
var _target: Node2D:
	get:
		return vision_area.target

func enter() -> void:
	animation_playback.travel("chase")

func state_physics_process(delta: float) -> void:
	if not _target:
		state_transition.emit(self, idle_state)
		return
	
	var target_dx = _target.global_position.x - sporeling.global_position.x
	if abs(target_dx) <= _attack_range:
		state_transition.emit(self, attack_state)
		return
	
	sporeling.direction = signf(target_dx)
	if floor_detector.is_colliding():
		if floor_detector.get_collision_point().distance_to(sporeling.global_position) < sporeling.min_to_floor:
			movement_component.move_y_axis(stats.speed.value * _y_speed_multiplier, -1)
		else:
			movement_component.stop_y_axis()
	else:
		movement_component.move_y_axis(stats.speed.value * _y_speed_multiplier, 1)
	movement_component.move_x_axis(stats.speed.value * _chase_speed_multiplier,sporeling.direction)
	
	move_and_slide()
