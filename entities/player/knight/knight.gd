extends Player
class_name Knight

@onready var crouch_c_shape: CollisionShape2D = $CrouchCShape
@onready var melee_attack_component: MeleeAttackComponent = $MeleeAttackComponent
@onready var fsm: KnightFSM = $FSM
@onready var ground_state: KnightState = $FSM/Ground
@onready var hurt_state: KnightState = $FSM/Hurt
@onready var die_state: KnightState = $FSM/Die

var hazard_knockback_velocity: Vector2 = Vector2(100.0, -100.0)

func revive():
	super.revive()
	fsm.force_state_transition(ground_state)

func _update_facing_direction():
	if direction == 1.0:
		flip_nodes.scale.x = 1.0
		crouch_c_shape.position.x = abs(crouch_c_shape.position.x)
		melee_attack_component.scale.x = 1.0
		hurt_box_component.scale.x = 1.0
	elif direction == -1.0:
		flip_nodes.scale.x = -1.0
		crouch_c_shape.position.x = -abs(crouch_c_shape.position.x)
		melee_attack_component.scale.x = -1.0
		hurt_box_component.scale.x = -1.0

func _on_getting_hurt(attack: Attack) -> void:
	if fsm.current_state == die_state:
		return
	
	var success = stats.receive_attack(attack)
	
	if not success:
		return
	
	if is_instance_valid(event_bus):
		event_bus.player_health_changed.emit(stats.current_health, stats.current_max_health)
	
	match attack.attack_type:
		Attack.AttackType.ON_HIT:
			direction = -attack.attack_direction
			velocity.x = attack.attack_direction * attack.knockback_velocity.x
			velocity.y = attack.knockback_velocity.y
		Attack.AttackType.TOUCH_HAZARD:
			velocity.x = -direction * hazard_knockback_velocity.x
			velocity.y = hazard_knockback_velocity.y
	move_and_slide()
	
	if stats.current_health > 0:
		fsm.force_state_transition(hurt_state)
	else:
		fsm.force_state_transition(die_state)
