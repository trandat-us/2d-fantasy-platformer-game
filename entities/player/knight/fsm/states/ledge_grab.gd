extends KnightState

@export var ground_state: KnightState
@export var fall_state: KnightState

var is_climbing_up: bool

func enter():
	is_climbing_up = false
	movement_component.stop()
	animation_playback.travel("grab_idle")

func state_physics_process(delta: float):
	if Input.is_action_just_pressed("stop_grabbing"):
		movement_component.move_x_axis(1.0, -knight.direction)
		movement_component.move_and_slide()
		state_transition.emit(self, fall_state)
		return
	
	if Input.is_action_just_pressed("jump") and not is_climbing_up:
		is_climbing_up = true
		animation_playback.travel("ledge_grab")
		return

func _do_climbing_up():
	var tween = create_tween()
	tween.tween_property(knight, "global_position:y", knight.global_position.y - 50, 0.3).set_ease(Tween.EASE_IN)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ledge_grab":
		state_transition.emit(self, ground_state)
