extends FireWormState

@export var idle_state: FireWormState

func enter():
	animation_playback.travel("take_hit")

func state_physics_process(delta: float):
	if fire_worm.is_on_floor():
		state_transition.emit(self, idle_state)
		return
	
	movement_component.apply_gravity(delta)
	movement_component.move_and_slide()
