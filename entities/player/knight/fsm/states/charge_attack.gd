extends KnightState

@onready var hold_timer: Timer = $HoldTimer

@export var ground_state: KnightState
@export var fall_state: KnightState
@export var normal_attack_state: KnightState
@export var melee_attack_component: MeleeAttackComponent

var _modifier: float = -230.0
var _damage_scale: float = 0.8
var _is_add_modifier: bool

func enter():
	_is_add_modifier = false
	hold_timer.start()

func exit():
	if _is_add_modifier:
		stats.speed.remove_modifier_flat(_modifier)
	
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
			movement_component.move_x_axis(stats.speed.value, axis_input)
		else:
			movement_component.stop_x_axis()
	
	movement_component.move_and_slide()

func _on_hold_timer_timeout() -> void:
	stats.speed.add_modifier_flat(_modifier)
	_is_add_modifier = true
	
	var damage = Damage.new(
		Utils.roll_crit_damage(
			stats.attack.value * _damage_scale,
			stats.crit_rate.value,
			stats.crit_damage.value,
		)
	)
	melee_attack_component.damage = damage
	
	animation_playback.travel("attack_charge")
