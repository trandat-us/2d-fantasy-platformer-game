extends EnemyFiniteStateMachine
class_name SporelingFiniteStateMachine

@export var floor_detector: RayCast2D
@export var wall_detector: RayCast2D
@export var melee_attack_component: MeleeAttackComponent

func _assign_state_vars():
	super._assign_state_vars()
	
	for state in states:
		if state is SporelingState:
			state.floor_detector = floor_detector
			state.wall_detector = wall_detector
			state.melee_attack_component = melee_attack_component
