extends TextureButton
class_name FrameSlot

signal slot_focused(inv_item: InventoryItem)

@onready var item_icon: TextureRect = $ItemIcon
@onready var amount_label: Label = $AmountLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var inventory_item: InventoryItem:
	set(value):
		inventory_item = value
		refresh()

func refresh():
	if inventory_item == null or inventory_item.is_empty():
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		item_icon.texture = null
		amount_label.text = ""
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		item_icon.texture = inventory_item.item.texture
		if inventory_item.amount > 1:
			amount_label.text = str(inventory_item.amount)
		else:
			amount_label.text = ""

func _on_focus_entered() -> void:
	slot_focused.emit(inventory_item)
	
	if inventory_item and not inventory_item.is_empty():
		animation_player.play("on_focus")

func _on_focus_exited() -> void:
	animation_player.play("RESET")
