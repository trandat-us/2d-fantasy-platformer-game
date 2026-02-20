extends FireWormState

@onready var idle_timer: Timer = $IdleTimer

@export var walk_state: FireWormState
@export var attack_state: FireWormState
@export var floor_detector: RayCast2D

func enter():
	animation_playback.travel("idle")
	idle_timer.wait_time = randf_range(8.0, 12.0)
	idle_timer.start()

func exit():
	idle_timer.stop()

func state_physics_process(delta: float):
	movement_component.apply_gravity(delta)
	movement_component.stop_x_axis()
	movement_component.move_and_slide()

func _on_idle_timer_timeout() -> void:
	if not floor_detector.is_colliding():
		fire_worm.direction = -fire_worm.direction
	
	state_transition.emit(self, walk_state)

func _on_target_detected(target: Node2D) -> void:
	state_transition.emit(self, attack_state)
