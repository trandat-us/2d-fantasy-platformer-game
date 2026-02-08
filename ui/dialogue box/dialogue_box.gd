extends Control
class_name DialogueBox

@onready var talker_name_label: Label = %TalkerNameLabel
@onready var dialogue_text_label: Label = %DialogueTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var talker_name: String:
	set(value):
		talker_name = value
		talker_name_label.text = talker_name

func start_dialogue():
	animation_player.play("show_up")
	await animation_player.animation_finished
