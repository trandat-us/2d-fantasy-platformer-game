extends Stats
class_name BaseStats

@export var max_health: ModifiableStat
@export var defense: ModifiableStat

var health: int:
	set(value):
		health = clampi(value, 0, max_health.value)
		stat_changed.emit(StatName.HEALTH, health)

func _init_stats() -> void:
	health = max_health.value
	
	max_health.changed.connect(func():
		stat_changed.emit(StatName.MAX_HEALTH, max_health.value)
		health = min(health, max_health.value)
	)
	defense.changed.connect(func():
		stat_changed.emit(StatName.DEFENSE, defense.value)
	)

func set_max_health():
	health = max_health.value
