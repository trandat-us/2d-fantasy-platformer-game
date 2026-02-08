extends Resource
class_name ShopItem

@export var item: Item
@export_range(0, 1000000, 1, "or_greater", "hide_control", "suffix:coin") var price: int = 1
@export_range(1, 1000000, 1, "or_greater", "hide_control") var amount: int = 1
