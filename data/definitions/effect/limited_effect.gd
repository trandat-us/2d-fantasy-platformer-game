extends Effect
class_name LimitedEffect

@export_range(0, 1000000, 0.01, "or_greater", "hide_control", "suffix:s") var duration: float = 30.0
@export var effects: Array[Effect]

var limited_timer: Timer

func is_applicable(context: Variant) -> bool:
	if not context is Player:
		return false
	
	if applying_context:
		return false
	
	if is_instance_valid(limited_timer):
		return false
	
	var can_apply := true
	for effect in effects:
		can_apply = can_apply and effect.is_applicable(context)
	
	return can_apply

func apply(context: Variant) -> void:
	if not is_applicable(context):
		return
	
	applying_context = context
	for effect in effects:
		effect.apply(applying_context)
	
	limited_timer = Timer.new()
	limited_timer.wait_time = duration
	limited_timer.one_shot = true
	limited_timer.timeout.connect(func():
		for effect in effects:
			effect.reverse()
		limited_timer.queue_free()
		applying_context = null
	)
	applying_context.add_child(limited_timer)
	
	limited_timer.start()
