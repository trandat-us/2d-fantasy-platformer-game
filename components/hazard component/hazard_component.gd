@tool
extends Area2D
class_name HazardComponent

@onready var damage_timer: Timer = $DamageTimer

@export var hazard: Node2D:
	set(value):
		hazard = value
		update_configuration_warnings()

var damage: Damage
var delay_time: float = 1.0:
	set(value):
		delay_time = value
		damage_timer.wait_time = delay_time
var entered_hurt_box: HurtBoxComponent

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not is_instance_valid(hazard):
		warnings.append("Hazard reference is missing.")
	
	return warnings

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxComponent:
		entered_hurt_box = area

func _on_area_exited(area: Area2D) -> void:
	if area == entered_hurt_box:
		entered_hurt_box = null 

func _process(delta: float) -> void:
	if not is_instance_valid(entered_hurt_box):
		return
	
	if damage_timer.is_stopped():
		var attack = Attack.new()
		attack.damage = damage
		attack.attacker = hazard
		attack.attack_type = Attack.AttackType.TOUCH_HAZARD
		entered_hurt_box.get_hurt.call(attack)
		
		damage_timer.start()
