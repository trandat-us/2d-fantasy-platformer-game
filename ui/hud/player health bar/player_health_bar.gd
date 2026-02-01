extends Control

@onready var hp_bar: ProgressBar = %HpBar
@onready var damage_bar: ProgressBar = %DamageBar
@onready var damage_timer: Timer = %DamageTimer

var event_bus: EventBus

func _ready() -> void:
	event_bus = get_tree().get_first_node_in_group("event_bus")
	
	if is_instance_valid(event_bus):
		event_bus.player_health_changed.connect(update_health_bar)

func _get_final_value(current_value: int, max_value: int) -> float:
	return (float(current_value) / float(max_value)) * 100.0

func init_health_bar(current_health: int, max_health: int) -> void:
	var final_value := _get_final_value(current_health, max_health)
	hp_bar.value = final_value
	damage_bar.value = final_value

func update_health_bar(current_health: int, max_health: int) -> void:
	var final_value := _get_final_value(current_health, max_health)
	
	if final_value < hp_bar.value:
		damage_timer.start()
	else:
		damage_bar.value = final_value
	
	hp_bar.value = final_value

func _on_damage_timer_timeout() -> void:
	create_tween() \
		.tween_property(damage_bar, "value", hp_bar.value, 0.2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
