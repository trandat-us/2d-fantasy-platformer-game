extends FiniteStateMachine
class_name EnemyFiniteStateMachine

@export var enemy: Enemy
@export var animation_tree: AnimationTree
@export var movement_component: MovementComponent
@export var hurt_box_component: HurtBoxComponent
@export var vision_area: VisionArea

func _assign_state_vars():
	for state in states:
		if state is EnemyState:
			state.enemy = enemy
			state.animation_tree = animation_tree
			state.animation_playback = animation_tree["parameters/playback"]
			state.movement_component = movement_component
			state.hurt_box_component = hurt_box_component
			state.vision_area = vision_area
