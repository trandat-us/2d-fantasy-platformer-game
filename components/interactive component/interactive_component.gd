@tool
extends Area2D
class_name InteractiveComponent

var interact: Callable = func(interactor: Node2D) -> void:
	pass

var show_hint: Callable = func():
	pass

var hide_hint: Callable = func():
	pass
