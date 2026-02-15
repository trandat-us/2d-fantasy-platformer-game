@tool
extends Node2D

@onready var interactive_component: InteractiveComponent = $InteractiveComponent
@onready var animation_player: AnimationPlayer = $InputHint/AnimationPlayer
@onready var input_hint_label: Label = $InputHint/Label

@export var end_tunnel: Node2D:
	set(value):
		end_tunnel = value
		update_configuration_warnings()

func _is_end_tunnel_valid() -> bool:
	if not is_instance_valid(end_tunnel):
		return false
	
	if end_tunnel.scene_file_path != scene_file_path:
		return false
	
	if end_tunnel == self:
		return false
	
	return true

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not is_instance_valid(end_tunnel):
		warnings.append("End tunnel reference is missing.")
	
	if is_instance_valid(end_tunnel):
		if end_tunnel.scene_file_path != scene_file_path:
			warnings.append("Two end tunnels are not the same scene")
			
		if end_tunnel == self:
			warnings.append("Cannot connect to self.")
	
	return warnings

func _ready() -> void:
	interactive_component.interact = _on_interact
	
	_update_input_hint_label()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_instance_valid(input_hint_label):
		_update_input_hint_label()

func _update_input_hint_label():
	input_hint_label.text = "[F] " + tr("GAME_DOOR_LABEL_ENTER")

func _on_interact(interactor: Node2D):
	if not _is_end_tunnel_valid():
		return
	
	if interactor is Player:
		interactor.global_position = end_tunnel.global_position

func _on_show_hint():
	animation_player.play("show_hint")

func _on_hide_hint():
	animation_player.play("hide_hint")
