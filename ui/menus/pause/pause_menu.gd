extends CanvasLayer
class_name PauseMenu

signal option_pressed(option: String)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var enabled: bool = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not enabled:
			return
		
		if animation_player.is_playing():
			return
		
		if get_tree().paused:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()

func close() -> void:
	animation_player.play("disappear")
	await animation_player.animation_finished
	get_tree().paused = false

func open() -> void:
	get_tree().paused = true
	animation_player.play("appear")

func _on_resume_button_pressed() -> void:
	close()
	option_pressed.emit("resume")

func _on_save_button_pressed() -> void:
	SaveManager.save_game()
	option_pressed.emit("save")

func _on_settings_button_pressed() -> void:
	SettingsManager.show_settings_menu()
	option_pressed.emit("settings")

func _on_exit_button_pressed() -> void:
	option_pressed.emit("exit")
