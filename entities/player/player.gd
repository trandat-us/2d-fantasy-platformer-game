extends CharacterBody2D
class_name Player

@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite_2d: Sprite2D = $FlipNodes/Sprite2D
@onready var flip_nodes: Node2D = $FlipNodes
@onready var default_c_shape: CollisionShape2D = $DefaultCShape
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var point_light_2d: PointLight2D = $PointLight2D

@export var stats: PlayerStats
@export var input_enabled = false

var event_bus: EventBus
var direction: float = 1.0: 
	set(value):
		if value == 0.0:
			return
		direction = signf(value)
		_update_facing_direction()

func _ready() -> void:
	hurt_box_component.get_hurt = _on_getting_hurt
	
	event_bus = get_tree().get_first_node_in_group("event_bus")
	apply_floor_snap()

func check_horizontal_movement_input() -> float:
	var axis = Input.get_axis("move_left", "move_right")
	if axis: 
		direction = axis
	
	return axis

func enable_input() -> void:
	input_enabled = true
	
func disable_input() -> void:
	input_enabled = false

func disable_camera_smoothing() -> void:
	camera_2d.limit_smoothed = false
	camera_2d.position_smoothing_enabled = false

func enable_camera_smoothing() -> void:
	camera_2d.limit_smoothed = true
	camera_2d.position_smoothing_enabled = true

func enable_light_point():
	point_light_2d.enabled = true

func disable_light_point():
	point_light_2d.enabled = false

func revive():
	stats.reset_current_stats()
	event_bus.player_revived.emit()
	event_bus.player_health_changed.emit(stats.current_health, stats.current_max_health)

func _update_facing_direction() -> void:
	if direction == 1.0:
		flip_nodes.scale.x = 1.0
	elif direction == -1.0:
		flip_nodes.scale.x = -1.0

func _on_getting_hurt(attack: Attack) -> void:
	pass
