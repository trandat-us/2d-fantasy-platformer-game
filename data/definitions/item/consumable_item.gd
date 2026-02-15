extends Item
class_name ConsumableItem

@export var effects: Array[Effect]

func has_function() -> bool:
	return true

func use(context: Variant) -> bool:
	if effects.is_empty():
		return false
	
	var is_applicable := true
	for e in effects:
		is_applicable = is_applicable and e.is_applicable(context)
	
	if not is_applicable:
		return false
	
	for e in effects:
		e.apply(context)
	
	return true
