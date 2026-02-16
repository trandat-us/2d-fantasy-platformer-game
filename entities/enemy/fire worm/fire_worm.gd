extends Enemy
class_name FireWorm

@onready var vision_area: Area2D = $VisionArea
@onready var fsm: FireWormFSM = $FSM
@onready var idle_state: FireWormState = $FSM/Idle
@onready var hurt_state: FireWormState = $FSM/Hurt
@onready var die_state: FireWormState = $FSM/Die

func _on_getting_hurt(attack: Attack) -> void:
	if not attack.is_valid():
		return
	
	var amount = Utils.calculate_damage(attack.damage, stats.defense.value)
	stats.health -= amount
	
	direction = -attack.attack_direction
	if stats.health > 0:
		movement_component.set_velocity(attack.knockback_velocity, attack.attack_direction)
		movement_component.move_and_slide()
		
		fsm.force_state_transition(hurt_state)
	else:
		enemy_health_bar.hide()
		fsm.force_state_transition(die_state)

func revive():
	await get_tree().create_timer(4.0).timeout
	stats.health = stats.max_health.value
	global_position = initial_position
	vision_area.target = null
	await get_tree().physics_frame
	fsm.force_state_transition(idle_state)

func _update_facing_direction() -> void:
	super._update_facing_direction()
	
	vision_area.flip(direction)

func _on_player_revived():
	vision_area.set_deferred("monitoring", true)

func _on_player_died():
	vision_area.set_deferred("monitoring", false)
	vision_area.target = null
