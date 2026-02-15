extends VBoxContainer
class_name ItemDetailContainer

signal inventory_item_updated

@onready var icon_texture: TextureRect = %IconTexture
@onready var item_name_label: Label = %ItemNameLabel
@onready var item_amount_label: Label = %ItemAmountLabel
@onready var item_description_label: Label = %ItemDescriptionLabel
@onready var item_use_button: Button = $ItemUseButton

var opener: Node2D
var inv_item: InventoryItem:
	set(value):
		inv_item = value
		if is_node_ready():
			display()
var item: Item:
	get:
		return inv_item.item

func display():
	if inv_item != null and not inv_item.is_empty():
		visible = true
		icon_texture.texture = item.texture
		item_name_label.text = item.name
		item_description_label.text = item.description
		item_amount_label.text = str(inv_item.amount)
		
		var item_script = item.get_script()
		if item_script == Item:
			item_use_button.visible = false
		else:
			item_use_button.visible = true
			if item_script == ConsumableItem:
				item_use_button.text = "Consume"
			elif item_script == EquipmentItem:
				if item.is_equipped:
					item_use_button.text = "Unequip"
				else:
					item_use_button.text = "Equip"
	else:
		conceal()

func conceal():
	visible = false
	
	icon_texture.texture = null
	item_name_label.text = ""
	item_description_label.text = ""
	item_amount_label.text = ""

func _on_item_use_button_pressed() -> void:
	if item is ConsumableItem:
		var success = item.use(opener)
		
		if not success:
			return
		
		var result = opener.inventory.reduce_item(inv_item, 1)
		match result:
			Inventory.REDUCED_ITEM_EMPTY:
				get_viewport().gui_release_focus()
				inv_item = null
			Inventory.REDUCED_ITEM_REMAINING:
				display()
		inventory_item_updated.emit()
	elif item is EquipmentItem:
		var success = item.use(opener)
		if not success:
			return
		
		display()
