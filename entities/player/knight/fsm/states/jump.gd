extends KnightState

@export var fall_state: KnightState

func enter():
	animation_playback.travel("jump")
	movement_component.apply_jump_velocity(stats.jump_velocity)
	movement_component.move_and_slide()

func state_physics_process(delta: float):
	if knight.velocity.y >= 0:
		state_transition.emit(self, fall_state)
		return
	
	movement_component.apply_gravity(delta)
	
	var axis = knight.check_horizontal_movement_input()
	if axis: 
		movement_component.move_x_axis(stats.walk_speed, axis)
	
	movement_component.move_and_slide()
