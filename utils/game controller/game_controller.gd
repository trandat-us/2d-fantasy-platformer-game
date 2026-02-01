extends Node
class_name GameController

@onready var map_container: Node2D = $MapContainer
@onready var pause_menu: PauseMenu = $HUD/PauseMenu
@onready var player_health_bar: Control = $HUD/PlayerHealthBar

@export var player_scene: PackedScene

var current_map: Map
var player: Player

func _ready() -> void:
	SceneManager.loading_scene_started.connect(_on_scene_manager_transition_started)
	SceneManager.loading_scene_finished.connect(_on_scene_manager_transition_ended)
	
	player = player_scene.instantiate()

func init_scene(scene_data: Variant) -> void:
	pause_menu.enabled = false
	
	var save_data = SaveManager.get_save_data()
	
	var map_scene = load(save_data.map_scene) as PackedScene
	current_map = map_scene.instantiate()
	map_container.add_child(current_map)
	current_map.move_spawn_point(save_data.player.position)
	current_map.add_player(player)
	current_map.setup_player()
	
	player_health_bar.init_health_bar(player.stats.current_health, player.stats.current_max_health)
	player.direction = save_data.player.direction

func _on_pause_menu_option_pressed(option: String) -> void:
	if option == "exit":
		map_container.process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().paused = false
		SceneManager.change_to_scene_file("res://ui/menus/main/main_menu.tscn", self)

func _on_scene_manager_transition_started() -> void:
	pause_menu.enabled = false
	
	if is_instance_valid(player):
		player.disable_input()

func _on_scene_manager_transition_ended() -> void:
	pause_menu.enabled = true
	current_map = get_tree().get_first_node_in_group("map")
	
	if is_instance_valid(player):
		player.enable_input()

func _on_event_bus_player_died() -> void:
	await get_tree().create_timer(2).timeout
	
	current_map.cleanup_scene()
	
	var save_data = SaveManager.get_save_data()
	current_map.move_spawn_point(save_data.player.position)
	current_map.add_player(player)
	current_map.setup_player()
	
	player.revive()
	player.direction = save_data.player.direction
