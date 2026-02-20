extends SporelingState

@export var chase_state: SporelingState
@export var floor_detector: RayCast2D

@export var max_rise_speed: float = 300.0
@export var rise_acceleration: float = 500.0

func enter() -> void:
	animation_playback.travel("hurt")

func state_physics_process(delta: float) -> void:
	if not floor_detector.is_colliding():
		state_transition.emit(self, chase_state)
		return
	
	movement_component.apply_air_control(
		max_rise_speed,
		rise_acceleration,
		delta,
		-1
	)
	move_and_slide()
