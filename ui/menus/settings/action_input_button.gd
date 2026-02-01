extends Button

@onready var action_name_label: Label = $MarginContainer/HBoxContainer/ActionNameLabel
@onready var action_input_label: Label = $MarginContainer/HBoxContainer/ActionInputLabel

func set_action_name(new_name: String):
	action_name_label.text = new_name

func set_action_input(new_input: String):
	action_input_label.text = new_input
