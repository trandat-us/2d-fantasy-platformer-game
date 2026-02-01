# enemy_stats.gd
extends BaseStats
class_name EnemyStats

@export_group("Movement")
@export var patrol_speed: float = 30.0
@export var chase_speed: float = 70.0

@export_group("Combat")
@export var attack_damage: int = 15
@export var attack_range: float = 60.0
@export var knockback_velocity: Vector2 = Vector2(100.0, -150.0)

@export_group("Others")
@export var detect_range: float = 300.0
