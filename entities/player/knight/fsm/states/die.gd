extends KnightState

@export var hurt_box_component: HurtBoxComponent

var _should_handle_dead_state: bool = false

func enter() -> void:
	_should_handle_dead_state = false
	hurt_box_component.enabled = false
	animation_playback.travel("die")

func exit() -> void:
	_should_handle_dead_state = false
	hurt_box_component.enabled = true

func state_physics_process(delta: float) -> void:
	if knight.is_on_floor():
		movement_component.stop()
		
		if _should_handle_dead_state: 
			event_bus.player_died.emit()
			_should_handle_dead_state = false
	
	movement_component.apply_gravity(delta)
	movement_component.move_and_slide()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		_should_handle_dead_state = true
