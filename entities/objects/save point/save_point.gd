extends Node2D
class_name SavePoint

@onready var game_saved_animation_player: AnimationPlayer = $GameSavedLabel/AnimationPlayer
@onready var interactive_component: InteractiveComponent = $InteractiveComponent
@onready var interactive_hint: InteractiveHint = $InteractiveComponent/InteractiveHint

func _ready() -> void:
	interactive_component.interact = _on_interact
	
	_update_input_hint_label()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_instance_valid(interactive_hint):
		_update_input_hint_label()

func _update_input_hint_label():
	interactive_hint.hint_text = "[" + "F" + "] " + tr("GAME_LABEL_SAVE_GAME")

func _on_interact(interactor: Node2D):
	if game_saved_animation_player.is_playing():
		return
	
	if interactor is Player:
		game_saved_animation_player.play("notify")
		interactor.revive()
		SaveManager.save_game()
