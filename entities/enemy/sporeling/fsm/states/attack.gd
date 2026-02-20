extends SporelingState

enum AttackPhase {
	READY,
	STARTING,
	FALLING,
	LANDING,
	RISING
}

@onready var cooldown: Timer = $Cooldown

@export var idle_state: SporelingState
@export var chase_state: SporelingState
@export var floor_detector: RayCast2D
@export var vision_area: VisionArea
@export var melee_attack_component: MeleeAttackComponent

@export_group("Attack Settings")
@export_range(0.001, 1000000, 0.001, "hide_control", "or_greater", "suffix:px") var attack_range: float = 5.0
@export_range(0.001, 1000000, 0.001, "hide_control", "or_greater") var rise_speed_multiplier: float = 1.2

var attack_phase: AttackPhase = AttackPhase.READY

func enter() -> void:
	if cooldown.is_stopped():
		_start_attack()
	else:
		attack_phase = AttackPhase.READY
		
	var damage = Damage.new()
	damage.amount = stats.attack_damage.value
	melee_attack_component.damage = damage

func exit() -> void:
	cooldown.stop()
	attack_phase = AttackPhase.READY
	melee_attack_component.damage = null

func state_process(delta: float) -> void:
	if attack_phase == AttackPhase.READY and cooldown.is_stopped():
		_start_attack()

func state_physics_process(delta: float) -> void:
	if attack_phase == AttackPhase.READY:
		_check_state_transitions()
		
	match attack_phase:
		AttackPhase.READY, AttackPhase.STARTING, AttackPhase.LANDING:
			movement_component.stop()
		AttackPhase.FALLING:
			_handle_falling(delta)
		AttackPhase.RISING:
			_handle_rising()
	move_and_slide()

func _start_attack() -> void:
	attack_phase = AttackPhase.STARTING
	animation_playback.travel("attack_smash_start")

func _check_state_transitions() -> void:
	if not vision_area.target:
		state_transition.emit(self, idle_state)
		return
	
	var distance_to_target = abs(vision_area.target.global_position.x - sporeling.global_position.x)
	if distance_to_target > attack_range:
		state_transition.emit(self, chase_state)

func _handle_falling(delta: float) -> void:
	if sporeling.is_on_floor():
		attack_phase = AttackPhase.LANDING
		animation_playback.travel("attack_smash_end")
	else:
		movement_component.apply_gravity(delta)

func _handle_rising() -> void:
	if not floor_detector.is_colliding():
		cooldown.start()
		attack_phase = AttackPhase.READY
		return
	
	var collision_point := floor_detector.get_collision_point()
	var distance_to_floor := collision_point.distance_to(sporeling.global_position)
	
	if distance_to_floor < sporeling.min_to_floor:
		var rise_speed = stats.speed.value * rise_speed_multiplier
		movement_component.move_y_axis(rise_speed, -1)

func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		&"attack_smash_start":
			attack_phase = AttackPhase.FALLING
		&"attack_smash_end":
			attack_phase = AttackPhase.RISING

func _on_cooldown_timeout() -> void:
	if attack_phase == AttackPhase.READY:
		_start_attack()
