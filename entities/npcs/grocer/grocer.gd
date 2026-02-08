extends NPC

@export var item_shop_list: Array[ShopItem]

func _on_interact(interactor: Node2D):
	if interactor is Player:
		event_bus.player_open_item_shop.emit(item_shop_list, "Food Shop", interactor)
