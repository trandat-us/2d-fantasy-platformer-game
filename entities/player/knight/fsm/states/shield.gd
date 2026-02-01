extends KnightState

@export var ground_state: KnightState

func enter():
	animation_playback.travel("shield_up")

func exit() -> void:
	is_shield_up = false

func state_physics_process(delta: float):
	if Input.is_action_just_released("shield_up"):
		animation_playback.travel("shield_bash")
	
	movement_component.stop_x_axis()
	movement_component.move_and_slide()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shield_bash":
		state_transition.emit(self, ground_state)
	elif anim_name == "shield_up":
		is_shield_up = true
