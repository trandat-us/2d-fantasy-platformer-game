extends CanvasLayer
class_name ItemShop

const ITEM_SHOP_BAR = preload("res://ui/item shop/item_shop_bar.tscn")

@onready var item_inventory_v_box: VBoxContainer = %ItemInventoryVBox
@onready var shop_name_label: Label = %ShopNameLabel

@export var item_list: Array[ShopItem]
var shop_name: String
var opener: Node2D

func _ready() -> void:
	_create_shop()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()

func _create_shop():
	for child in item_inventory_v_box.get_children():
		child.queue_free()
	
	shop_name_label.text = shop_name
	
	for shop_item in item_list:
		var bar = ITEM_SHOP_BAR.instantiate() as ItemShopBar
		bar.shop_item = shop_item
		bar.item_bought.connect(_on_item_bought)
		item_inventory_v_box.add_child(bar)

func _on_item_bought(item_info: ShopItem):
	if opener is Player:
		opener.inventory.add_item(item_info.item, item_info.amount)

func _on_close_button_pressed() -> void:
	queue_free()
