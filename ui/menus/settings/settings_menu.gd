extends CanvasLayer
class_name SettingsMenu

@export var initial_panel: int = 0

@onready var button_v_box: VBoxContainer = %ButtonVBox
@onready var settings_panel: Control = %SettingsPanel

# Display settings controls
@onready var window_mode_option: OptionButton = %WindowModeOption
@onready var brightness_slider: HSlider = %BrightnessSlider

@onready var keybinding_settings: ScrollContainer = %KeybindingSettings

# Audio settings controls
@onready var master_volume_slider: HSlider = %MasterVolumeSlider
@onready var bgm_slider: HSlider = %BGMSlider
@onready var sfx_slider: HSlider = %SFXSlider

# Others settings controls
@onready var language_option: OptionButton = %LanguageOption

var window_mode_indexes: Dictionary = {
	DisplayServer.WINDOW_MODE_FULLSCREEN: 0,
	DisplayServer.WINDOW_MODE_MAXIMIZED: 1,
	DisplayServer.WINDOW_MODE_WINDOWED: 2
}
var lang_code_indexes: Dictionary = {
	"en": 0,
	"es": 1,
	"ja": 2,
	"vi": 3
}

func _ready() -> void:
	for button in button_v_box.get_children():
		var idx = button.get_index()
		button.pressed.connect(_set_panel_visibility.bind(idx))
	
	_present_settings()
	_set_panel_visibility(initial_panel)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()

func _present_settings():
	# Display settings
	var display_settings = SettingsManager.load_display_settings()
	window_mode_option.select(window_mode_indexes[display_settings.window_mode])
	brightness_slider.value = display_settings.brightness
	
	keybinding_settings.create_input_buttons_list()
	
	# Audio settings
	var audio_settings = SettingsManager.load_audio_settings()
	master_volume_slider.value = audio_settings.master_volume
	bgm_slider.value = audio_settings.background_music
	sfx_slider.value = audio_settings.sfx
	
	# Others settings
	var others_settings = SettingsManager.load_others_settings()
	language_option.select(lang_code_indexes[others_settings.lang])

func _set_panel_visibility(panel_index: int):
	for panel in settings_panel.get_children():
		panel.visible = panel.get_index() == panel_index

func _on_close_button_pressed() -> void:
	queue_free()

func _on_window_mode_selected(index: int) -> void:
	SettingsManager.save_display_settings("window_mode", window_mode_indexes.find_key(index))

func _on_brightness_changed(value: float) -> void:
	SettingsManager.save_display_settings("brightness", value)

func _on_master_volume_changed(value: float) -> void:
	SettingsManager.save_audio_settings("master_volume", value)

func _on_bgm_changed(value: float) -> void:
	SettingsManager.save_audio_settings("background_music", value)

func _on_sfx_changed(value: float) -> void:
	SettingsManager.save_audio_settings("sfx", value)

func _on_language_selected(index: int) -> void:
	SettingsManager.save_others_settings("lang", lang_code_indexes.find_key(index))
