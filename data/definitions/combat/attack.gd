extends Resource
class_name Attack

enum AttackType {
	ON_HIT,
	TOUCH_HAZARD
}

var damage: Damage
var attacker: Node
var attack_type: AttackType = AttackType.ON_HIT
var attack_direction: float
var knockback_velocity: Vector2
