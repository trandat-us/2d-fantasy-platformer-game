extends SporelingState

@onready var fly_timer: Timer = $FlyTimer

@export var idle_state: SporelingState
@export var chase_state: SporelingState
@export var floor_detector: RayCast2D
@export var wall_detector: RayCast2D

var _y_speed_multiplier: float = 0.7

func enter() -> void:
	animation_playback.travel("fly")
	fly_timer.wait_time = randf_range(8.0, 12.0)
	fly_timer.start()

func exit() -> void:
	fly_timer.stop()

func state_physics_process(delta: float) -> void:
	if wall_detector.is_colliding():
		sporeling.direction = -sporeling.direction
	
	if floor_detector.is_colliding():
		if floor_detector.get_collision_point().distance_to(sporeling.global_position) < sporeling.min_to_floor:
			movement_component.move_y_axis(stats.speed.value * _y_speed_multiplier, -1)
		else:
			movement_component.stop_y_axis()
	else:
		movement_component.move_y_axis(stats.speed.value * _y_speed_multiplier, 1)
	
	movement_component.move_x_axis(stats.speed.value, sporeling.direction)
	move_and_slide()

func _on_fly_timer_timeout() -> void:
	state_transition.emit(self, idle_state)

func _on_target_detected(target: Node2D) -> void:
	state_transition.emit(self, chase_state)
