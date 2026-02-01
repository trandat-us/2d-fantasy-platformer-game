@tool
extends Area2D
class_name MeleeAttackComponent

@export var character: CharacterBody2D:
	set(value):
		character = value
		update_configuration_warnings()

var damage: Damage

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not is_instance_valid(character):
		warnings.append("character reference is missing.")
	
	return warnings

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxComponent:
		var attack = Attack.new()
		attack.damage = damage
		attack.attack_direction = signf(area.global_position.x - character.global_position.x)
		attack.knockback_velocity = character.stats.knockback_velocity
		attack.attacker = character
		area.get_hurt.call(attack)
