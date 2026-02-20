extends Enemy
class_name Sporeling

@onready var floor_detector: RayCast2D = $Pivot/FloorDetector
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var melee_attack_component: MeleeAttackComponent = $MeleeAttackComponent
@onready var fsm: SporelingFSM = $FSM
@onready var idle_state: SporelingState = $FSM/Idle
@onready var hurt_state: SporelingState = $FSM/Hurt
@onready var die_state: SporelingState = $FSM/Die

@export_range(100.0, 1000000, 0.01, "hide_control", "or_greater", "suffix:px") var min_to_floor: float = 100.0

func _ready() -> void:
	super._ready()
	
	register_node_dir(melee_attack_component, "scale:x", 1.0, -1.0)
	
	floor_detector.target_position = Vector2(0.0, min_to_floor)

func _on_getting_hurt(attack: Attack) -> void:
	if not attack.is_valid():
		return
	
	var amount = Utils.calculate_damage(attack.damage, stats.defense.value)
	stats.health -= amount
	
	direction = -attack.attack_direction
	if stats.health > 0:
		movement_component.set_velocity(attack.knockback_velocity, attack.attack_direction)
		move_and_slide()
		fsm.force_state_transition(hurt_state)
	else:
		enemy_health_bar.hide()
		fsm.force_state_transition(die_state)

func revive():
	await get_tree().create_timer(4.0).timeout
	stats.health = stats.max_health.value
	global_position = initial_position
	await get_tree().physics_frame
	fsm.force_state_transition(idle_state)

func _on_player_revived():
	vision_area.enabled = true

func _on_player_died():
	vision_area.enabled = false
