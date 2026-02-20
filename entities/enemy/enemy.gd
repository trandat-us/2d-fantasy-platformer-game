extends CharacterBody2D
class_name Enemy

const COLLECTIBLE = preload("uid://cwif3e5rm6fov")

class NodeDirection:
	var property: NodePath
	var right_value: Variant
	var left_value: Variant
	
	func get_dir_value(dir: float) -> Variant:
		if dir == 1.0:
			return right_value
		elif dir == -1.0:
			return left_value
		return null

@onready var pivot: Node2D = $Pivot
@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var vision_area: VisionArea = $VisionArea
@onready var enemy_health_bar: ProgressBar = $EnemyHealthBar
@onready var point_light_2d: PointLight2D = $PointLight2D

@export_range(1, 1000000, 0.01, "or_greater", "hide_control", "suffix:px") var max_init_pos_gap: float = 500.0
@export var stats: EnemyStats
@export var loot_box: Array[LootItem]

var direction: float:
	set(value):
		if value == 0.0:
			return
		direction = signf(value)
		update_node_dir()
var node_dirs: Dictionary[Node, NodeDirection]
var event_bus: EventBus
var initial_position: Vector2

func _ready() -> void:
	register_node_dir(pivot, "scale:x", 1.0, -1.0)
	register_node_dir(hurt_box_component, "scale:x", 1.0, -1.0)
	register_node_dir(vision_area, "scale:x", 1.0, -1.0)
	
	initial_position = global_position
	hurt_box_component.get_hurt = _on_getting_hurt
	direction = 1.0 if pivot.scale.x == 1.0 else -1.0
	enemy_health_bar.init_stats(stats)
	
	event_bus = get_tree().get_first_node_in_group("event_bus")
	if is_instance_valid(event_bus):
		event_bus.player_revived.connect(_on_player_revived)
		event_bus.player_died.connect(_on_player_died)
	
	apply_floor_snap()

func register_node_dir(node: Node, property: NodePath, right_value: Variant, left_value: Variant) -> void:
	if node_dirs.has(node):
		var node_dir = node_dirs.get(node) as NodeDirection
		node_dir.property = property
		node_dir.right_value = right_value
		node_dir.left_value = left_value
	else:
		var node_dir = NodeDirection.new()
		node_dir.property = property
		node_dir.right_value = right_value
		node_dir.left_value = left_value
		node_dirs[node] = node_dir

func unregister_node_dir(node: Node) -> void:
	if node_dirs.has(node):
		node_dirs.erase(node)

func update_node_dir() -> void:
	for node in node_dirs:
		var node_dir = node_dirs.get(node) as NodeDirection
		node.set_indexed(node_dir.property, node_dir.get_dir_value(direction))

func pick_random_direction():
	direction = 1 if randf() > 0.5 else -1

func enable_point_light():
	point_light_2d.enabled = true

func disable_point_light():
	point_light_2d.enabled = false

func drop_loot_box() -> void:
	for loot in loot_box:
		if loot == null or loot.is_empty():
			continue
		
		var drop_amount := loot.get_drop_amount()
		if drop_amount == 0:
			continue
		
		var instance = COLLECTIBLE.instantiate() as Collectible
		instance.item = loot.item
		instance.amount = drop_amount
		instance.global_position =  global_position
		
		var map = get_tree().get_first_node_in_group("map")
		map.add_child(instance)
		
		randomize()
		instance.apply_impulse(Vector2(randf_range(-150, 150), randf_range(-200, -250)))

func revive():
	pass

func _on_getting_hurt(attack: Attack) -> void:
	pass

func _on_player_revived():
	pass

func _on_player_died():
	pass
