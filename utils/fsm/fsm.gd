extends Node
class_name FiniteStateMachine

@export var initial_state: State

var states: Array[State]
var current_state: State

func _ready() -> void:
	store_state_children()
	enter_initial_state()

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.state_unhandled_input(event)

func _process(delta: float) -> void:
	if current_state:
		current_state.state_process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.state_physics_process(delta)

func _on_state_transition(cur_state: State, next_state: State):
	if current_state != cur_state:
		return
		
	if next_state == null:
		return
		
	if current_state:
		current_state.exit()
		
	current_state = next_state
	current_state.enter()

func store_state_children():
	for child in get_children():
		if child is State:
			child.state_transition.connect(_on_state_transition)
			states.append(child)

func enter_initial_state():
	if initial_state:
		current_state = initial_state
		current_state.enter()

func force_state_transition(next_state: State):
	if current_state:
		current_state.exit()
	
	current_state = next_state
	current_state.enter()
