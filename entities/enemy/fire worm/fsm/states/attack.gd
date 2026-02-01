extends FireWormState

const FIRE_BALL = preload("res://entities/enemy/fire worm/fire ball/fire_worm_fire_ball.tscn")

@onready var vision_area: Area2D = %VisionArea
@onready var fire_ball_emitting_position: Marker2D = %FireBallEmittingPosition
@onready var cooldown: Timer = $Cooldown

@export var idle_state: FireWormState
@export_flags_2d_physics var target_mask: int
@export var max_angle: float = 30.0:
	get:
		return deg_to_rad(max_angle)

var can_change_direction: bool
var can_attack: bool
var is_attacking: bool = false 

var _should_transition_to_idle: bool = false
var _firing_dir: Vector2
var _attack: Attack

func enter():
	can_attack = cooldown.is_stopped()
	can_change_direction = true
	is_attacking = false
	_should_transition_to_idle = false

func exit() -> void:
	_firing_dir = Vector2.ZERO
	_attack = null

func state_process(delta: float) -> void:
	if vision_area.target and can_change_direction:
		fire_worm.direction = signf(vision_area.target.global_position.x - fire_worm.global_position.x)

func state_physics_process(delta: float):
	if _should_transition_to_idle and not is_attacking:
		state_transition.emit(self, idle_state)
		return
	
	if not vision_area.target and not is_attacking:
		state_transition.emit(self, idle_state)
		return
	
	if can_attack and not is_attacking:
		animation_playback.travel("attack")
		is_attacking = true
	elif not is_attacking:
		animation_playback.travel("idle")

func _lock_direction():
	can_change_direction = false

func _unlock_direction():
	can_change_direction = true
 
func _calculate_firing_direction() -> void:
	var emitting_direction: Vector2
	
	if fire_worm.direction == 1.0:
		emitting_direction = Vector2.RIGHT
	elif fire_worm.direction == -1.0:
		emitting_direction = Vector2.LEFT
	
	if not vision_area.target:
		_firing_dir = emitting_direction.normalized()
		return
	
	var forward = emitting_direction.normalized()
	var raw_dir = (vision_area.target.global_position - fire_ball_emitting_position.global_position).normalized()
	var angle_diff = emitting_direction.angle_to(raw_dir)
	var clamped_angle = clamp(angle_diff, -max_angle, max_angle)
	
	_firing_dir = forward.rotated(clamped_angle).normalized()

func _init_attack() -> void:
	var _damage = Damage.new()
	_damage.amount = stats.attack_damage
	
	_attack = Attack.new()
	_attack.damage = _damage
	_attack.knockback_velocity = stats.knockback_velocity
	_attack.attacker = fire_worm

func _spawn_fire_ball():
	var fire_ball = FIRE_BALL.instantiate() as FireWormFireBall
	fire_ball.collision_mask = target_mask
	fire_ball.global_position = fire_ball_emitting_position.global_position
	fire_ball.direction = _firing_dir
	fire_ball.attack = _attack
	
	var parent_node = get_tree().get_first_node_in_group("map")
	parent_node.add_child(fire_ball)

func _on_vision_area_target_undetected() -> void:
	if is_attacking:
		_should_transition_to_idle = true
	else:
		state_transition.emit(self, idle_state)

func _on_cooldown_timeout() -> void:
	can_attack = true

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
		can_attack = false
		cooldown.start()
		
		if _should_transition_to_idle:
			state_transition.emit(self, idle_state)
