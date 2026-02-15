extends CharacterBody2D
class_name Enemy

const COLLECTIBLE = preload("uid://cwif3e5rm6fov")

@onready var flip_nodes: Node2D = $FlipNodes
@onready var sprite_2d: Sprite2D = $FlipNodes/Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var enemy_health_bar: ProgressBar = $EnemyHealthBar

@export var stats: EnemyStats
@export var loot_box: Array[LootItem]

var direction: float:
	set(value):
		if value == 0.0:
			return
		direction = signf(value)
		_update_facing_direction()
var event_bus: EventBus

func _ready() -> void:
	hurt_box_component.get_hurt = _on_getting_hurt
	direction = 1.0 if sprite_2d.flip_h == false else -1.0
	enemy_health_bar.init_health_bar(stats)
	
	event_bus = get_tree().get_first_node_in_group("event_bus")
	if is_instance_valid(event_bus):
		event_bus.player_revived.connect(_on_player_revived)
		event_bus.player_died.connect(_on_player_died)
	
	apply_floor_snap()

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
		instance.apply_impulse(Vector2(randf_range(-100, 100), randf_range(-150, -200)))

func revive():
	pass

func _update_facing_direction() -> void:
	if direction == 1.0:
		flip_nodes.scale.x = 1.0
		hurt_box_component.scale.x = 1.0
		collision_shape_2d.position.x = abs(collision_shape_2d.position.x)
	elif direction == -1.0:
		flip_nodes.scale.x = -1.0
		hurt_box_component.scale.x = -1.0
		collision_shape_2d.position.x = -abs(collision_shape_2d.position.x)

func _on_getting_hurt(attack: Attack) -> void:
	pass

func _on_player_revived():
	pass

func _on_player_died():
	pass
