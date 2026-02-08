extends HBoxContainer

@onready var header_label: Label = %HeaderLabel
@onready var marker_h_box: HBoxContainer = %MarkerHBox
@onready var left_sections_container: MarginContainer = %LeftSectionsContainer
var initial_section: int = 0

func _ready() -> void:
	for child in marker_h_box.get_children():
		if child is MarkerButton:
			var idx = child.get_index()
			child.pressed.connect(_set_focused_section.bind(idx))
	
	_set_focused_section(initial_section)

func _set_focused_section(idx: int):
	for button in marker_h_box.get_children():
		if button.get_index() == idx:
			button.z_index = 2
			header_label.text = button.get_meta("header_name")
		else:
			button.z_index = 0
	
	for section in left_sections_container.get_children():
		if section.get_index() == idx:
			if section.has_method("display"):
				section.display()
		else:
			if section.has_method("conceal"):
				section.conceal()
