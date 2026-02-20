@tool
extends Node
class_name MovementComponent

@export var character: CharacterBody2D:
	set(value):
		character = value
		update_configuration_warnings()

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity: Vector2:
	set(value): 
		character.velocity = value
	get: 
		return character.velocity

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not is_instance_valid(character):
		warnings.append("character reference is missing.")
	
	return warnings

# ========== Basic Movement ==========

func stop() -> void:
	velocity = Vector2.ZERO

func stop_x_axis() -> void:
	velocity.x = 0.0

func stop_y_axis() -> void:
	velocity.y = 0.0

func move_x_axis(speed: float, direction: float = 1.0) -> void:
	velocity.x = direction * speed

func move_y_axis(speed: float, direction: float = 1.0) -> void:
	velocity.y = direction * speed

func set_velocity(inst_velocity: Vector2, direction: float = 1.0) -> void:
	velocity.x = direction * inst_velocity.x
	velocity.y = inst_velocity.y

func move_and_slide() -> void:
	if is_instance_valid(character):
		character.move_and_slide()

# ========== Acceleration/Deceleration ==========

func move_with_acceleration(
	target_speed: float,
	acceleration: float,
	delta: float,
	direction: float = 1.0
) -> void:
	var target_velocity = direction * target_speed
	velocity.x = move_toward(velocity.x, target_velocity, acceleration * delta)

func apply_friction(friction: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, friction * delta)

func lerp_velocity(target_velocity: Vector2, weight: float, delta: float) -> void:
	velocity = velocity.lerp(target_velocity, weight * delta)

func smooth_stop(deceleration: float, delta: float) -> void:
	velocity = velocity.lerp(Vector2.ZERO, deceleration * delta)

# ========== Gravity ==========

func apply_gravity(delta: float) -> void:
	if not character.is_on_floor():
		velocity.y += gravity * delta

func apply_custom_gravity(gravity_multiplier: float, delta: float) -> void:
	if not character.is_on_floor():
		velocity.y += gravity * gravity_multiplier * delta

func apply_terminal_velocity(max_fall_speed: float) -> void:
	velocity.y = min(velocity.y, max_fall_speed)

# ========== Aerial Movement ==========

func apply_air_control(
	target_speed: float,
	air_control: float,
	delta: float,
	direction: float
) -> void:
	var target_velocity = direction * target_speed
	velocity.y = move_toward(velocity.y, target_velocity, air_control * delta)

# ========== Wall Movement ==========

func is_on_wall() -> bool:
	return character.is_on_wall() if is_instance_valid(character) else false

func get_wall_normal() -> Vector2:
	return character.get_wall_normal() if is_instance_valid(character) else Vector2.ZERO

func apply_wall_slide(slide_speed: float) -> void:
	if is_on_wall() and velocity.y > 0:
		velocity.y = min(velocity.y, slide_speed)

func apply_wall_jump(jump_force: Vector2) -> void:
	var wall_normal = get_wall_normal()
	velocity.x = wall_normal.x * jump_force.x
	velocity.y = jump_force.y

# ========== Others ==========

func apply_jump_power(jump_power: float) -> void:
	velocity.y = jump_power
