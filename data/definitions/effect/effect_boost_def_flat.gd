extends Effect
class_name EffectBoostDefFlat

@export_range(1, 1000000, 1, "or_greater", "hide_control") var amount: int = 10

func is_applicable(context: Variant) -> bool:
	if applying_context:
		return false
	
	return context is Player

func apply(context: Variant) -> void:
	if not is_applicable(context):
		return
	
	applying_context = context
	applying_context.stats.defense.add_modifier_flat(amount)

func reverse() -> void:
	if not applying_context:
		return
	
	applying_context.stats.defense.remove_modifier_flat(amount)
	applying_context = null
