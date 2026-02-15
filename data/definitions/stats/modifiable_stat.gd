extends Resource
class_name ModifiableStat

@export_range(0, 1000000, 0.01, "or_greater", "hide_control") var base: float = 1.0
@export var use_integer: bool = false

var value: Variant:
	set(value):
		return
	get:
		return get_current_value()

var _flat_modifiers: Array[float] = []
var _multiplier_modifiers: Array[float] = []

func _to_string() -> String:
	return str(get_current_value())

func add_modifier_flat(m: float) -> void:
	_flat_modifiers.append(m)
	emit_changed()

func add_modifier_multiplier(m: float) -> void:
	_multiplier_modifiers.append(m)
	emit_changed()

func remove_modifier_flat(m: float) -> void:
	_flat_modifiers.erase(m)
	emit_changed()

func remove_modifier_multiplier(m: float) -> void:
	_multiplier_modifiers.erase(m)
	emit_changed()

func get_current_value() -> Variant:
	var current_value := base
	
	for f in _flat_modifiers:
		current_value += f
	
	for m in _multiplier_modifiers:
		current_value *= m
	
	if use_integer:
		return roundi(current_value)
	else:
		return current_value
