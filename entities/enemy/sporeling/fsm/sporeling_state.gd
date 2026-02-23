extends EnemyState
class_name SporelingState

var sporeling: Sporeling:
	get:
		return enemy
var floor_detector: RayCast2D
var wall_detector: RayCast2D
var melee_attack_component: MeleeAttackComponent
