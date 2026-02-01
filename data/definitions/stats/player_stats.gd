# player_stats.gd
extends BaseStats
class_name PlayerStats

@export_group("Movement")
@export var walk_speed: float = 300.0
@export var crouch_speed: float = 80.0
@export var dash_speed: float = 900.0
@export var jump_velocity: float = -350.0

@export_group("Combat")
@export var normal_attack_damage: int = 20
@export var charge_attack_damage: int = 15
@export var knockback_velocity: Vector2 = Vector2(100.0, -150.0)

@export_group("Others")
@export var charge_attack_speed: float = 50.0
