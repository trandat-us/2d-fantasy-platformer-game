extends ScrollContainer

const ACTION_INPUT_BUTTON_SCENE = preload("res://ui/menus/settings/action_input_button.tscn")

@onready var action_list: VBoxContainer = $ActionList

var _is_remapping: bool = false
var _remapping_button: Button
var _remapping_action: String

var keybindings_settings = {}

func _ready() -> void:
	keybindings_settings = SettingsManager.load_keybindings_settings()

func create_input_buttons_list():
	for button in action_list.get_children():
		button.queue_free()
	
	for action in keybindings_settings:
		var button = ACTION_INPUT_BUTTON_SCENE.instantiate() as Button
		var keybinding_info = keybindings_settings[action] as KeyBindingInfo
		
		action_list.add_child(button)
		
		button.set_action_name(keybinding_info.action_as_text)
		button.set_action_input(keybinding_info.input_as_text)
		
		button.pressed.connect(_on_action_input_pressed.bind(button, action))

func _on_action_input_pressed(button: Button, action: String):
	_is_remapping = true
	_remapping_button = button
	_remapping_action = action
	_remapping_button.set_action_input(tr("KEYBINDINGS_LABEL_PRESS_KEY_TO_BIND") + "...")

func _input(event: InputEvent) -> void:
	if not _is_remapping:
		return
	
	if event.is_action_pressed("ui_cancel"):
		_remapping_button.set_action_input(keybindings_settings[_remapping_action].input_as_text)
		_cleanup()
		accept_event()
		return
	
	if event is InputEventKey || (event is InputEventMouseButton and event.is_pressed()):
		if event is InputEventMouseButton:
			event.double_click = false
		
		var keybinding_info = keybindings_settings[_remapping_action] as KeyBindingInfo
		keybinding_info.input = event
		
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				keybinding_info.input_as_text = "KEYBINDINGS_INPUT_LEFT_MOUSE_BUTTON"
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				keybinding_info.input_as_text = "KEYBINDINGS_INPUT_RIGHT_MOUSE_BUTTON"
		elif event is InputEventKey:
			if event.unicode == 0:
				keybinding_info.input_as_text = event.as_text()
			else:
				if event.unicode == 32:
					keybinding_info.input_as_text = "KEYBINDINGS_INPUT_SPACE"
				else:
					keybinding_info.input_as_text = String.chr(event.unicode).to_upper()
		
		SettingsManager.save_keybindings(_remapping_action, keybinding_info)
		keybindings_settings = SettingsManager.load_keybindings_settings()
		_remapping_button.set_action_input(keybindings_settings[_remapping_action].input_as_text)
		_cleanup()
	
	accept_event()

func _cleanup():
	_remapping_button = null
	_remapping_action = ""
	_is_remapping = false
