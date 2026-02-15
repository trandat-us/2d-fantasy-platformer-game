extends Node

func roll_crit_damage(damage: int, crit_rate: float, crit_damage: float) -> int:
	if randf() < (crit_rate / 100):
		return roundi(damage * (crit_damage / 100))
	else:
		return damage

func calculate_damage(damage: Damage, defense: int) -> int:
	if damage == null:
		return 0
	
	const k = 100.0
	return max(1, roundi(damage.amount * k / (k + defense)))
