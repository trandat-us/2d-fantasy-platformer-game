extends FiniteStateMachine
class_name FireWormFSM

@export var fire_worm: FireWorm
@export var animation_tree: AnimationTree
@export var movement_component: MovementComponent

func _ready() -> void:
	store_state_children()
	
	for state in states:
		if state is FireWormState:
			state.fire_worm = fire_worm
			state.stats = fire_worm.stats
			state.animation_tree = animation_tree
			state.animation_playback = animation_tree["parameters/playback"]
			state.movement_component = movement_component
			
	enter_initial_state()
