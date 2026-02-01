extends KnightState

@export var jump_state: KnightState
@export var fall_state: KnightState
@export var shield_state: KnightState
@export var crouch_state: KnightState
@export var dash_state: KnightState
@export var charge_attack_state: KnightState

var axis: float
var blend_animation = "parameters/ground/blend_position"

func enter():
	animation_playback.travel("ground")

func state_unhandled_input(event: InputEvent):
	if event.is_action_pressed("attack") and knight.input_enabled:
		state_transition.emit(self, charge_attack_state)

func state_process(delta: float):
	animation_tree.set(blend_animation, axis)
	
func state_physics_process(delta: float):
	if not knight.is_on_floor():
		state_transition.emit(self, fall_state)
		return
	
	if not knight.input_enabled:
		axis = 0.0
		movement_component.stop_x_axis()
	else:
		if Input.is_action_just_pressed("jump"):
			state_transition.emit(self, jump_state)
			return
		
		if Input.is_action_just_pressed("shield_up"):
			state_transition.emit(self, shield_state)
			return
		
		if Input.is_action_just_pressed("crouch"):
			state_transition.emit(self, crouch_state)
			return
		
		if Input.is_action_just_pressed("dash") and dash_state.can_dash:
			state_transition.emit(self, dash_state)
			return
		
		axis = knight.check_horizontal_movement_input()
		if axis:
			movement_component.move_x_axis(stats.walk_speed, axis)
		else:
			movement_component.move_x_axis(stats.walk_speed, axis)
	
	movement_component.move_and_slide()
