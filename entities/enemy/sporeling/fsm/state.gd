extends State
class_name SporelingState

var sporeling: Sporeling
var stats: EnemyStats:
	get:
		return sporeling.stats
var animation_tree: AnimationTree
var animation_playback: AnimationNodeStateMachinePlayback
var movement_component: MovementComponent

func move_and_slide() -> void:
	movement_component.move_and_slide()
