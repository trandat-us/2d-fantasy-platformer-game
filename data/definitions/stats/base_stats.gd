extends Resource
class_name BaseStats

@export var max_health: int = 100
@export var defense: int = 5

var current_max_health: int
var current_health: int:
	set(value):
		current_health = clampi(value, 0, current_max_health)
var current_defense: int

func _init() -> void:
	init_stats()

func init_stats() -> void:
	current_max_health = max_health
	current_health = current_max_health
	
	current_defense = defense

func reset_current_stats():
	current_health = current_max_health
	current_defense = defense

func receive_attack(attack: Attack) -> bool:
	var damage = attack.damage
	
	if damage.type == Damage.DamageType.DEATHBLOW:
		current_health = 0
		return true
	
	var amount = damage.amount
	if amount < 0:
		return false
	
	var real_amount = amount - current_defense
	current_health -= real_amount
	return true
