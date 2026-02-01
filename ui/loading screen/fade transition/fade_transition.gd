extends Control
class_name FadeTransition

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var show_screen_finished: Callable
var hide_screen_finished: Callable

func show_screen(cb: Callable):
	show_screen_finished = cb
	animation_player.play("fade_to_black")

func hide_screen(cb: Callable):
	hide_screen_finished = cb
	animation_player.play("fade_to_normal")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black" and show_screen_finished.is_valid():
		show_screen_finished.call()
	elif anim_name == "fade_to_normal" and hide_screen_finished.is_valid():
		hide_screen_finished.call()
