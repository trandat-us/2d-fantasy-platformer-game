extends CanvasLayer
class_name PlayerHealthBar

@onready var hp_bar: ProgressBar = %HpBar
@onready var damage_bar: ProgressBar = %DamageBar
@onready var damage_timer: Timer = %DamageTimer

func init_stats(stats: BaseStats) -> void:
	hp_bar.max_value = stats.max_health.value
	damage_bar.max_value = stats.max_health.value
	
	hp_bar.value = stats.health
	damage_bar.value = stats.health
	
	stats.stat_changed.connect(_on_stat_changed)

func update_health(health: int) -> void:
	var prev = hp_bar.value
	hp_bar.value = health
	
	if health < prev:
		damage_timer.start()
	else:
		damage_bar.value = health

func _on_damage_timer_timeout() -> void:
	create_tween() \
		.tween_property(damage_bar, "value", hp_bar.value, 0.2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

func _on_stat_changed(stat_name: StringName, value: Variant):
	match stat_name:
		StatName.MAX_HEALTH:
			hp_bar.max_value = value
			damage_bar.max_value = value
		StatName.HEALTH:
			update_health(value)
