extends Control
class_name InventoryContainer

const FRAME_SLOT = preload("res://ui/travel book/frame slot/frame_slot.tscn")

@onready var scroll_slider: VSlider = %ScrollSlider
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var grid_slot: GridContainer = %GridSlot

@export var inventory_section: InventorySection

var max_scroll_px: int = 224

func _on_scroll_slider_value_changed(value: float) -> void:
	scroll_container.scroll_vertical = roundi(max_scroll_px * (1 - value))

func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN or event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			scroll_slider.value = 1 - float(scroll_container.scroll_vertical) / max_scroll_px

func init_inventory(inv: Array[InventoryItem]):
	for i in range(inv.size()):
		var slot = grid_slot.get_child(i) as FrameSlot
		slot.inventory_item = inv[i]
		slot.slot_focused.connect(inventory_section._on_item_focused)

func refresh():
	for child in grid_slot.get_children():
		child.refresh()
