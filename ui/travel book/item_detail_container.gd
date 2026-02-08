extends VBoxContainer
class_name ItemDetailContainer

@onready var icon_texture: TextureRect = %IconTexture
@onready var item_name_label: Label = %ItemNameLabel
@onready var item_amount_label: Label = %ItemAmountLabel
@onready var item_description_label: Label = %ItemDescriptionLabel

var inv_item: InventoryItem

func display():
	if inv_item != null and not inv_item.is_empty():
		visible = true
		icon_texture.texture = inv_item.item.texture
		item_name_label.text = inv_item.item.name
		item_description_label.text = inv_item.item.description
		item_amount_label.text = str(inv_item.amount)
	else:
		conceal()

func conceal():
	visible = false
	icon_texture.texture = null
	item_name_label.text = ""
	item_description_label.text = ""
	item_amount_label.text = ""
