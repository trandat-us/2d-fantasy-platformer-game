extends FireWormState

@onready var walk_timer: Timer = $WalkTimer

@export var idle_state: FireWormState
@export var attack_state: FireWormState
@export var wall_detector: RayCast2D
@export var floor_detector: RayCast2D

func enter():
	animation_playback.travel("walk")
	walk_timer.wait_time = randf_range(15.0, 20.0)
	walk_timer.start()

func exit():
	walk_timer.stop()

func state_physics_process(delta: float):
	if fire_worm.is_on_floor():
		if not floor_detector.is_colliding():
			state_transition.emit(self, idle_state)
			return
			
		if wall_detector.is_colliding():
			fire_worm.direction = -fire_worm.direction
	
	movement_component.apply_gravity(delta)
	movement_component.move_x_axis(stats.speed.value, fire_worm.direction)
	movement_component.move_and_slide()

func _on_walk_timer_timeout() -> void:
	state_transition.emit(self, idle_state)

func _on_target_detected(target: Node2D) -> void:
	state_transition.emit(self, attack_state)
