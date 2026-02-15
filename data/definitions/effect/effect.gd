@abstract
extends Resource
class_name Effect

var applying_context: Variant

func is_applicable(context: Variant) -> bool:
	return false

func apply(context: Variant) -> void:
	pass

func reverse() -> void:
	pass
