@tool
extends Button

@onready var selected_bg: NinePatchRect = $SelectedBG
@onready var quest_name_label: Label = $QuestNameLabel
@export var quest_name: String:
	set(value):
		quest_name = value
		if is_node_ready():
			set_quest_name()

var quest_data: Variant

func _ready() -> void:
	set_quest_name()

func set_quest_name():
	quest_name_label.text = quest_name
			
	if quest_name.is_empty():
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED

func _on_focus_entered() -> void:
	if quest_name.is_empty():
		return
	
	selected_bg.visible = true

func _on_focus_exited() -> void:
	if quest_name.is_empty():
		return
	
	selected_bg.visible = false
