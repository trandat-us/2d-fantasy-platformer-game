extends Effect
class_name EffectHealFlat

@export_range(1, 1000000, 1, "or_greater", "hide_control", "suffix:hp") var amount: int = 10

func is_applicable(context: Variant) -> bool:
	if not context is Player:
		return false
	
	return not context.stats.health == context.stats.max_health.value

func apply(context: Variant) -> void:
	if not is_applicable(context):
		return
	
	context.stats.health += amount
