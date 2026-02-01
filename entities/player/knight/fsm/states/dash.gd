extends KnightState

@onready var dash_timer: Timer = $DashTimer
@onready var cooldown: Timer = $Cooldown

@export var ground_state: KnightState
@export var hurt_box_component: HurtBoxComponent

var can_dash: bool = true

func enter():
	hurt_box_component.enabled = false
	animation_playback.travel("dash")
	dash_timer.start()

func exit() -> void:
	hurt_box_component.enabled = true

func state_physics_process(delta: float):
	if can_dash:
		movement_component.move_x_axis(stats.dash_speed, knight.direction)
	
	movement_component.move_and_slide()

func _on_cooldown_timeout() -> void:
	can_dash = true

func _on_dash_timer_timeout() -> void:
	movement_component.stop_x_axis()
	can_dash = false
	cooldown.start()
	state_transition.emit(self, ground_state)
