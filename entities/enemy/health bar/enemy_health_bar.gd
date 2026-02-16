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

func init_stats(stats: EnemyStats):
	max_value = stats.max_health.value
	damage_bar.max_value = stats.max_health.value
	
	value = stats.health
	damage_bar.value = stats.health
	
	stats.stat_changed.connect(_on_stat_changed)

func update_health(health: int) -> void:
	if health < value:
		show()
		damage_timer.start()
		show_timer.start()
	else:
		damage_bar.value = health
	value = health

func _on_stat_changed(stat_name: StringName, _value: Variant) -> void:
	match stat_name:
		StatName.MAX_HEALTH:
			max_value = _value
			damage_bar.max_value = _value
		StatName.HEALTH:
			update_health(_value)
	
func _on_damage_timer_timeout() -> void:
	create_tween().tween_property(damage_bar, "value", value, 0.4) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

func _on_show_timer_timeout() -> void:
	if show_mode == SHOW_MODE.WHEN_UPDATED:
		hide()
