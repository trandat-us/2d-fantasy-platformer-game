extends EnemyFiniteStateMachine
class_name FireWormFiniteStateMachine

@export var wall_detector: RayCast2D
@export var floor_detector: RayCast2D

func _assign_state_vars():
	super._assign_state_vars()
	
	for state in states:
		if state is FireWormState:
			state.wall_detector = wall_detector
			state.floor_detector = floor_detector
