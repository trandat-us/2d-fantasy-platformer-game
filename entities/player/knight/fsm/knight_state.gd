extends State
class_name KnightState

var knight: Knight
var stats: PlayerStats:
	get:
		return knight.stats

var event_bus: EventBus:
	get:
		return knight.event_bus
var animation_tree: AnimationTree
var animation_playback: AnimationNodeStateMachinePlayback
var movement_component: MovementComponent

var is_shield_up: bool = false
