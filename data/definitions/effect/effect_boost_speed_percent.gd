extends Effect
class_name EffectBoostSpeedPercent

@export_range(1, 1000000, 0.01, "or_greater", "hide_control", "suffix:%") var percent: float = 25.0:
	get:
		return 1 + percent / 100.0

func is_applicable(context: Variant) -> bool:
	if applying_context:
		return false
	
	return context is Player

func apply(context: Variant) -> void:
	if not is_applicable(context):
		return
	
	applying_context = context
	applying_context.stats.speed.add_modifier_multiplier(percent)

func reverse() -> void:
	if not applying_context:
		return
	
	applying_context.stats.speed.remove_modifier_multiplier(percent)
	applying_context = null
