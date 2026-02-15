extends VBoxContainer

@onready var equipment_header_label: Label = %EquipmentHeaderLabel
@onready var equipment_part_button: HBoxContainer = %EquipmentPartButton
@onready var selection_frames: Control = %SelectionFrames
@onready var equipment_detail_container: EquipmentDetailContainer = %EquipmentDetailContainer

var frame_count: int
var current_frame = 0

func _ready() -> void:
	frame_count = equipment_part_button.get_child_count()
	
	for button in equipment_part_button.get_children():
		var idx = button.get_index()
		button.pressed.connect(_set_selection_frame.bind(idx))
	
	_set_selection_frame(current_frame)

func _set_selection_frame(idx: int):
	current_frame = idx
	for frame in selection_frames.get_children():
		frame.visible = current_frame == frame.get_index()
		if frame.visible:
			equipment_header_label.text = frame.get_meta("frame_name")

func display():
	visible = true
	equipment_detail_container.visible = true

func conceal():
	visible = false
	equipment_detail_container.visible = false

func init_stats_detail(opener: Node2D):
	if opener is Player:
		equipment_detail_container.init_stats(opener.stats)

func _on_left_button_pressed() -> void:
	_set_selection_frame((current_frame - 1 + frame_count) % frame_count)

func _on_right_button_pressed() -> void:
	_set_selection_frame((current_frame + 1 + frame_count) % frame_count)
