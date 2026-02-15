extends CanvasLayer
class_name TravelBook

@onready var inventory_section: VBoxContainer = %InventorySection
@onready var equipment_section: VBoxContainer = %EquipmentSection
var opener: Node2D

func _ready() -> void:
	if opener is Player:
		inventory_section.init_inventory(opener)
		equipment_section.init_stats_detail(opener)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()
