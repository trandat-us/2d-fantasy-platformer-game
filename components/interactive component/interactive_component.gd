@tool
extends Area2D
class_name InteractiveComponent

@export var can_interact: bool = true:
	set(value):
		can_interact = value
		if can_interact:
			set_deferred("monitorable", true)
		else:
			set_deferred("monitorable", false)

var input_hint: InteractiveHint

var interact: Callable = func(interactor: Node2D) -> void:
	pass

func show_hint():
	if input_hint:
		input_hint.show_hint()

func hide_hint():
	if input_hint:
		input_hint.hide_hint()

func _on_child_entered_tree(node: Node) -> void:
	if node is InteractiveHint and input_hint == null:
		input_hint = node

func _on_child_exiting_tree(node: Node) -> void:
	if input_hint == node:
		input_hint = null
