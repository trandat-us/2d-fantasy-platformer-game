extends Resource
class_name Stats

signal stat_changed(stat_name: StringName, value: Variant)

func _init() -> void:
	_init_stats.call_deferred()

func _init_stats() -> void:
	pass
