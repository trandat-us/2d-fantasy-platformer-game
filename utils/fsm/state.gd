extends Node
class_name State

signal state_transition(cur_state: State, next_state: State)

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func state_unhandled_input(event: InputEvent) -> void:
	pass
	
func state_process(delta: float) -> void:
	pass

func state_physics_process(delta: float) -> void:
	pass
