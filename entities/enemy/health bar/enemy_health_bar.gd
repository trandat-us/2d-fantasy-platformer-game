extends ProgressBar

enum SHOW_MODE {
	ALWAYS,
	WHEN_UPDATED
}

@onready var damage_bar: ProgressBar = $DamageBar
@onready var damage_timer: Timer = $DamageTimer
@onready var show_timer: Timer = $ShowTimer

@export var show_mode: SHOW_MODE = SHOW_MODE.ALWAYS

func _ready() -> void:
	if show_mode == SHOW_MODE.WHEN_UPDATED:
		hide()

func _get_final_value(cur_value: int, maximum_value: int) -> float:
	return (float(cur_value) / float(maximum_value)) * 100.0

func init_health_bar(current_health: int, max_health: int):
	var final_value := _get_final_value(current_health, max_health)
	value = final_value
	damage_bar.value = final_value

func update_health_bar(current_health: int, max_health: int):
	var final_value := _get_final_value(current_health, max_health)
	
	if final_value < value:
		show()
		damage_timer.start()
		show_timer.start()
	
	value = final_value

func _on_damage_timer_timeout() -> void:
	create_tween().tween_property(damage_bar, "value", value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_show_timer_timeout() -> void:
	if show_mode == SHOW_MODE.WHEN_UPDATED:
		hide()
