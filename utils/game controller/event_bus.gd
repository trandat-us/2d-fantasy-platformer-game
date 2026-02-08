extends Node
class_name EventBus

signal player_revived
signal player_died
signal player_health_changed(current_health: int, max_health: int)
signal player_start_dialogue(talker_name: String)
signal player_finish_dialogue
signal player_open_item_shop(item_shop_list: Array[ShopItem], shop_name: String, opener: Node2D)
