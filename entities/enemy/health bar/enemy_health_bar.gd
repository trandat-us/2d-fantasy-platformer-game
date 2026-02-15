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

func init_health_bar(stats: EnemyStats):
	max_value = stats.max_health.value
	damage_bar.max_value = stats.max_health.value
	
	value = stats.health
	damage_bar.value = stats.health
	
	#stats.current_health_changed.connect(update_health_bar)

func update_health_bar(cur_hp: int) -> void:
	if cur_hp < value:
		show()
		damage_timer.start()
		show_timer.start()
	
	value = cur_hp

func _on_damage_timer_timeout() -> void:
	create_tween().tween_property(damage_bar, "value", value, 0.4) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

func _on_show_timer_timeout() -> void:
	if show_mode == SHOW_MODE.WHEN_UPDATED:
		hide()
