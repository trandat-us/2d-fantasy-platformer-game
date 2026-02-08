extends NinePatchRect
class_name ItemShopBar

signal item_bought(item_info: ShopItem)

@onready var item_texture_rect: TextureRect = %ItemTexture
@onready var item_name_label: Label = %ItemName
@onready var item_price_label: Label = %ItemPrice
@onready var item_amount_label: Label = %ItemAmount

var shop_item: ShopItem

func _ready() -> void:
	if shop_item:
		item_texture_rect.texture = shop_item.item.texture
		item_name_label.text = shop_item.item.name
		item_price_label.text = str(shop_item.price)
		
		if shop_item.amount > 1:
			item_amount_label.text = str(shop_item.amount)
		else:
			item_amount_label.text = ""

func _on_buy_button_pressed() -> void:
	item_bought.emit(shop_item)
