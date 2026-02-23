extends State
class_name EnemyState

var enemy: Enemy
var stats:
	get:
		return enemy.stats

var animation_tree: AnimationTree
var animation_playback: AnimationNodeStateMachinePlayback:
	get:
		if animation_tree and animation_tree.tree_root is AnimationNodeStateMachine:
			return animation_tree["parameters/playback"]
		return null

var movement_component: MovementComponent
var hurt_box_component: HurtBoxComponent
var vision_area: VisionArea

func move_and_slide() -> void:
	if enemy:
		enemy.move_and_slide()
