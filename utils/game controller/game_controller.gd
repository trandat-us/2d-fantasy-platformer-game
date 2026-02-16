extends Node
class_name GameController

const ITEM_SHOP = preload("uid://ku0ksu6vrwa0")
const TRAVEL_BOOK = preload("uid://b2884bwnctdyl")

@onready var map_container: Node2D = $MapContainer
@onready var player_health_bar: PlayerHealthBar = $HUD/PlayerHealthBar
@onready var pause_menu: PauseMenu = $HUD/PauseMenu
@onready var hud: Control = $HUD

@export var player_scene: PackedScene

var current_map: Map
var player: Player

var item_shop: ItemShop
var travel_book: TravelBook

func _ready() -> void:
	SceneManager.loading_scene_started.connect(_on_scene_manager_transition_started)
	SceneManager.loading_scene_finished.connect(_on_scene_manager_transition_ended)
	
	player = player_scene.instantiate()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tackle_travel_book"):
		_handle_tackle_travel_book()

func init_scene(scene_data: Variant) -> void:
	pause_menu.enabled = false
	
	var save_data = SaveManager.get_save_data()
	
	var map_scene = load(save_data.map_scene) as PackedScene
	current_map = map_scene.instantiate()
	map_container.add_child(current_map)
	current_map.init_scene(null)
	current_map.move_spawn_point(save_data.player.position)
	current_map.add_player(player)
	current_map.setup_player()
	
	player_health_bar.init_stats(player.stats)
	player.direction = save_data.player.direction

func disable_player_input():
	pause_menu.enabled = false
	player.disable_input()

func enable_player_input():
	pause_menu.enabled = true
	player.enable_input()

func _handle_tackle_travel_book():
	if item_shop:
		return
	
	if travel_book:
		travel_book.queue_free()
	else:
		disable_player_input()
		travel_book = TRAVEL_BOOK.instantiate()
		travel_book.tree_exited.connect(enable_player_input)
		travel_book.opener = player
		hud.add_child(travel_book)

func _on_pause_menu_option_pressed(option: String) -> void:
	if option == "exit":
		map_container.process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().paused = false
		SceneManager.change_to_scene_file("res://ui/menus/main/main_menu.tscn", self)

func _on_scene_manager_transition_started() -> void:
	disable_player_input()

func _on_scene_manager_transition_ended() -> void:
	enable_player_input()
	current_map = get_tree().get_first_node_in_group("map")

func _on_player_died() -> void:
	await get_tree().create_timer(2).timeout
	
	current_map.cleanup_scene()
	
	var save_data = SaveManager.get_save_data()
	current_map.move_spawn_point(save_data.player.position)
	current_map.add_player(player)
	current_map.setup_player()
	
	player.revive()
	player.direction = save_data.player.direction

func _on_player_start_dialogue(talker_name: String) -> void:
	# Create dialogue session here
	pass

func _on_player_finish_dialogue() -> void:
	# Close dialogue session here
	pass

func _on_player_open_item_shop(item_shop_list: Array[ShopItem], shop_name: String, opener: Node2D) -> void:
	if travel_book:
		return
	
	if item_shop:
		return
	
	disable_player_input()
	item_shop = ITEM_SHOP.instantiate()
	item_shop.tree_exited.connect(enable_player_input)
	item_shop.item_list = item_shop_list
	item_shop.shop_name = shop_name
	item_shop.opener = opener
	
	hud.add_child(item_shop)
