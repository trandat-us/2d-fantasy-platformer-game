extends KnightState

@export var ground_state: KnightState

var time_seek_request = "parameters/take_hit/TimeSeek/seek_request"
var _should_transition_to_ground: bool

func enter() -> void:
	animation_playback.travel("take_hit")
	animation_tree.set(time_seek_request, 0.0)
	
	_should_transition_to_ground = false

func exit() -> void:
	_should_transition_to_ground = false

func state_physics_process(delta: float) -> void:
	movement_component.apply_gravity(delta)
	
	if knight.is_on_floor():
		movement_component.stop_x_axis()
		
		if _should_transition_to_ground:
			state_transition.emit(self, ground_state)
			return
	
	movement_component.move_and_slide()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "take_hit":
		_should_transition_to_ground = true
