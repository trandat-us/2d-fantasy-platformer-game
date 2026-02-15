# player_stats.gd
extends BaseStats
class_name PlayerStats

@export var jump_velocity: float = -350.0
@export var knockback_velocity: Vector2 = Vector2(100.0, -150.0)
@export var speed: ModifiableStat
@export var attack: ModifiableStat
@export var crit_rate: ModifiableStat
@export var crit_damage: ModifiableStat

func _init_stats() -> void:
	super._init_stats()
	
	speed.changed.connect(func(): stat_changed.emit(StatName.SPEED, speed.value))
	attack.changed.connect(func(): stat_changed.emit(StatName.ATTACK, attack.value))
	crit_rate.changed.connect(func(): stat_changed.emit(StatName.CRIT_RATE, crit_rate.value))
	crit_damage.changed.connect(func(): stat_changed.emit(StatName.CRIT_DAMAGE, crit_damage.value))
