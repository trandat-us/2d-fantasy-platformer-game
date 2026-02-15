# enemy_stats.gd
extends BaseStats
class_name EnemyStats

@export var speed: ModifiableStat
@export var attack_damage: ModifiableStat
@export var knockback_velocity: Vector2 = Vector2(100.0, -150.0)
