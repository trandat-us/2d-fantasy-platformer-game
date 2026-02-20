extends SporelingState

@onready var idle_timer: Timer = $IdleTimer

@export var fly_state: SporelingState
@export var chase_state: SporelingState

func enter() -> void:
	animation_playback.travel("idle")
	idle_timer.wait_time = randf_range(8.0, 12.0)
	idle_timer.start()

func exit() -> void:
	idle_timer.stop()

func state_physics_process(delta: float) -> void:
	movement_component.stop()
	move_and_slide()

func _on_idle_timer_timeout() -> void:
	if sporeling.initial_position.distance_to(sporeling.global_position) < sporeling.max_init_pos_gap:
		sporeling.pick_random_direction()
	else:
		sporeling.direction = -sporeling.direction
	state_transition.emit(self, fly_state)

func _on_target_detected(target: Node2D) -> void:
	state_transition.emit(self, chase_state)
