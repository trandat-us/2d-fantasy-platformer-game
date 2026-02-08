@tool
extends Control
class_name InteractiveHint

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_multiline() var hint_text: String = "Input Hint":
	set(value):
		hint_text = value
		if is_node_ready():
			label.text = hint_text

func _ready() -> void:
	label.text = hint_text
	
	if Engine.is_editor_hint():
		label.modulate.a = 1

func show_hint():
	animation_player.play("show_hint")

func hide_hint():
	animation_player.play("hide_hint")
