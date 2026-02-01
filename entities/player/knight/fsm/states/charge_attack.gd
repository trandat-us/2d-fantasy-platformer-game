extends KnightState

@onready var hold_timer: Timer = $HoldTimer

@export var ground_state: KnightState
@export var fall_state: KnightState
@export var normal_attack_state: KnightState
@export var melee_attack_component: MeleeAttackComponent

func enter():
	hold_timer.start()

func exit():
	hold_timer.stop()

func state_unhandled_input(event: InputEvent):
	if event.is_action_released("attack"):
		if hold_timer.is_stopped():
			state_transition.emit(self, ground_state)
		else:
			state_transition.emit(self, normal_attack_state)

func state_physics_process(delta: float):
	if not knight.is_on_floor():
		state_transition.emit(self, fall_state)
		return
	
	if not knight.input_enabled:
		state_transition.emit(self, ground_state)
		return
	
	if hold_timer.is_stopped():
		var axis_input = knight.check_horizontal_movement_input()
		if axis_input:
			movement_component.move_x_axis(stats.charge_attack_speed, axis_input)
		else:
			movement_component.stop_x_axis()
	
	movement_component.move_and_slide()

func _on_hold_timer_timeout() -> void:
	var damage = Damage.new()
	damage.amount = stats.charge_attack_damage
	melee_attack_component.damage = damage
	
	animation_playback.travel("attack_charge")
