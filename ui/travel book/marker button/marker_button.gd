@tool
extends Button
class_name MarkerButton

@onready var section_icon: TextureRect = $Background/SectionIcon

@export var icon_texture: Texture2D:
	set(value):
		icon_texture = value
		if is_node_ready():
			section_icon.texture = icon_texture

func _ready() -> void:
	if icon_texture:
		section_icon.texture = icon_texture
