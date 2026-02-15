extends Control

const GAME_CONTROLLER_SCENE = "uid://phpumvk55j1c"

func start_game():
	SceneManager.change_to_scene_file(GAME_CONTROLLER_SCENE, self)

func _on_start_button_pressed() -> void:
	start_game()

func _on_settings_button_pressed() -> void:
	SettingsManager.show_settings_menu()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
