@tool
extends Area2D
class_name HurtBoxComponent

@export var enabled: bool = true:
	set(value):
		enabled = value
		set_deferred("monitorable", enabled)

var get_hurt: Callable = func(attack: Attack) -> void:
	pass
