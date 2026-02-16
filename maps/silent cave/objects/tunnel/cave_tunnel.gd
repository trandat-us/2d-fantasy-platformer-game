@tool
extends Node2D

@onready var interactive_component: InteractiveComponent = $InteractiveComponent
@onready var interactive_hint: InteractiveHint = $InteractiveComponent/InteractiveHint

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
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_instance_valid(interactive_hint):
		_update_input_hint_label()

func _update_input_hint_label():
	interactive_hint.hint_text = "[F] " + tr("GAME_DOOR_LABEL_ENTER")

func _on_interact(interactor: Node2D):
	if not _is_end_tunnel_valid():
		return
	
	if interactor is Player:
		interactor.global_position = end_tunnel.global_position
