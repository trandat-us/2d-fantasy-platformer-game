@tool
extends RigidBody2D
class_name Collectible

@onready var sprite_2d: Sprite2D = $Pivot/Sprite2D

@export var item: Item:
	set(value):
		item = value
		if is_node_ready():
			if item:
				sprite_2d.texture = item.texture
			else:
				sprite_2d.texture = null
@export_range(1, 1000000, 1, "or_greater", "hide_control") var amount: int = 1

func _ready() -> void:
	if item:
		sprite_2d.texture = item.texture
