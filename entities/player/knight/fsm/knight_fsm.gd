extends FiniteStateMachine
class_name KnightFSM

@export var knight: Knight
@export var animation_tree: AnimationTree
@export var movement_component: MovementComponent

func _ready() -> void:
	store_state_children()
	
	for state in states:
		if state is KnightState:
			state.knight = knight
			state.stats = knight.stats
			state.animation_tree = animation_tree
			state.animation_playback = animation_tree["parameters/playback"]
			state.movement_component = movement_component
	
	enter_initial_state()

func is_shield_up():
	return current_state.is_shield_up
