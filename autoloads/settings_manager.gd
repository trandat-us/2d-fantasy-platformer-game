extends Node

const SETTINGS_FILE_PATH = "user://settings.cfg"
const DEFAULT_KEYBINDINGS = preload("res://data/default_keybindings.tres") as KeyBindings

var config = ConfigFile.new()
var settings_menu: SettingsMenu
var audio_bus_indexes: Dictionary = {
	"Master": AudioServer.get_bus_index("Master"),
	"BGM": AudioServer.get_bus_index("BGM"),
	"SFX": AudioServer.get_bus_index("SFX"),
}

func _ready() -> void:
	_load_config_file()
	_apply_settings()

func _load_config_file() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("display", "window_mode", DisplayServer.WINDOW_MODE_WINDOWED)
		config.set_value("display", "brightness", 1)
		
		var default_keybindings = DEFAULT_KEYBINDINGS.keybindings
		for keybinding_info in default_keybindings:
			config.set_value("keybindings", keybinding_info.action, keybinding_info)
		
		config.set_value("audio", "master_volume", 1)
		config.set_value("audio", "background_music", 1)
		config.set_value("audio", "sfx", 1)
		
		config.set_value("others", "lang", "en")
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func _apply_settings() -> void:
	_apply_display_settings()
	_apply_keybindings_settings()
	_apply_audio_settings()
	_apply_others_settings()

func _apply_display_settings() -> void:
	var display_settings = load_display_settings()
	# Window Mode
	DisplayServer.window_set_mode(display_settings.window_mode)
	# Brightness
	GlobalWorldEnvironment.environment.adjustment_brightness = display_settings.brightness

func _apply_keybindings_settings():
	var keybindings_settings = load_keybindings_settings()
	# Keybindings
	for action in keybindings_settings:
		var keybinding_info = keybindings_settings[action] as KeyBindingInfo
		if not InputMap.has_action(action):
			InputMap.add_action(action, 0.5)
		
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybinding_info.input)

func _apply_audio_settings() -> void:
	var audio_settings = load_audio_settings()
	# Master Volume
	AudioServer.set_bus_volume_db(audio_bus_indexes["Master"], linear_to_db(audio_settings.master_volume))
	# Background Music
	AudioServer.set_bus_volume_db(audio_bus_indexes["BGM"], linear_to_db(audio_settings.background_music))
	# SFX
	AudioServer.set_bus_volume_db(audio_bus_indexes["SFX"], linear_to_db(audio_settings.sfx))

func _apply_others_settings() -> void:
	var others_settings = load_others_settings()
	# Language
	TranslationServer.set_locale(others_settings.lang)

func show_settings_menu() -> void:
	var scene = load("res://ui/menus/settings/settings_menu.tscn") as PackedScene
	settings_menu = scene.instantiate()
	get_tree().root.add_child(settings_menu)

func save_display_settings(key: String, value: Variant) -> void:
	config.set_value("display", key, value)
	config.save(SETTINGS_FILE_PATH)
	_apply_display_settings()

func save_keybindings(key: String, value: Variant) -> void:
	config.set_value("keybindings", key, value)
	config.save(SETTINGS_FILE_PATH)
	_apply_keybindings_settings()

func save_audio_settings(key: String, value: Variant) -> void:
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	_apply_audio_settings()

func save_others_settings(key: String, value: Variant) -> void:
	config.set_value("others", key, value)
	config.save(SETTINGS_FILE_PATH)
	_apply_others_settings()

func load_display_settings() -> Dictionary:
	var display_settings = {}
	for key in config.get_section_keys("display"):
		display_settings[key] = config.get_value("display", key)
	
	return display_settings

func load_keybindings_settings() -> Dictionary:
	var keybindings_settings = {}
	for key in config.get_section_keys("keybindings"):
		keybindings_settings[key] = config.get_value("keybindings", key)
	
	return keybindings_settings

func load_audio_settings() -> Dictionary:
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
		
	return audio_settings

func load_others_settings() -> Dictionary:
	var others_settings = {}
	for key in config.get_section_keys("others"):
		others_settings[key] = config.get_value("others", key)
		
	return others_settings
