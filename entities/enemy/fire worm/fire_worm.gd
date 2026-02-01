extends Enemy
class_name FireWorm

@onready var vision_area: Area2D = $VisionArea
@onready var fsm: FireWormFSM = $FSM
@onready var hurt_state: FireWormState = $FSM/Hurt
@onready var die_state: FireWormState = $FSM/Die

func _on_getting_hurt(attack: Attack) -> void:
	var success = stats.receive_attack(attack)
	
	if not success:
		return
	
	direction = -attack.attack_direction
	if stats.current_health > 0:
		movement_component.set_velocity(attack.knockback_velocity, attack.attack_direction)
		movement_component.move_and_slide()
		
		enemy_health_bar.update_health_bar(stats.current_health, stats.current_max_health)
		fsm.force_state_transition(hurt_state)
	else:
		enemy_health_bar.hide()
		fsm.force_state_transition(die_state)

func _update_facing_direction() -> void:
	super._update_facing_direction()
	
	vision_area.flip(direction)

func _on_player_revived():
	vision_area.set_deferred("monitoring", true)

func _on_player_died():
	vision_area.set_deferred("monitoring", false)
	vision_area.target = null
