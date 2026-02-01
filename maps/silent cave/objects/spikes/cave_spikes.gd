@tool
extends Node2D

const SPIKES_SPRITE = preload("res://maps/silent cave/objects/spikes/cave_spikes_sprite.tscn")

@onready var sprite_holder: Node2D = $SpriteHolder
@onready var hazard_component: HazardComponent = $HazardComponent
@onready var collision_shape_2d: CollisionShape2D = $HazardComponent/CollisionShape2D

@export var damage: Damage
@export_range(0.001, 1000000, 0.001, "or_greater", "suffix:s") var delay_time: float = 1.0
@export var number_of_sprites: int = 1:
	set(value):
		number_of_sprites = max(1, value)
		
		if is_node_ready():
			_adjust_sprite_holder()

var _sprite_width = 16.0

func _ready() -> void:
	_adjust_sprite_holder()
	hazard_component.damage = damage
	hazard_component.delay_time = delay_time

func _adjust_sprite_holder():
	var total_width = _sprite_width * number_of_sprites
	var start_position = (-total_width  + _sprite_width) / 2
	
	for child in sprite_holder.get_children():
		child.queue_free()
	
	for i in range(number_of_sprites):
		var new_sprite = SPIKES_SPRITE.instantiate()
		var final_postion = start_position + i * _sprite_width
		sprite_holder.add_child(new_sprite)
		
		new_sprite.position = Vector2(final_postion, 0.0)
		new_sprite.owner = get_tree().edited_scene_root
	
	collision_shape_2d.shape.size.x = total_width
