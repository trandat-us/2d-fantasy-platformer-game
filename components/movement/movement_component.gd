@tool
extends Node
class_name MovementComponent

@export var character: CharacterBody2D:
	set(value):
		character = value
		update_configuration_warnings()

var gravity: float = ProjectSettings.get("physics/2d/default_gravity")
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

func stop():
	velocity = Vector2.ZERO

func stop_x_axis():
	velocity.x = 0.0

func stop_y_axis():
	velocity.y = 0.0

func move_x_axis(speed: float, direction: float = 1.0):
	velocity.x = direction * speed

func move_y_axis(speed: float, direction: float = 1.0):
	velocity.y = direction * speed

func apply_gravity(delta):
	if not character.is_on_floor():
		velocity.y += gravity * delta

func apply_jump_velocity(jump_velocity: float):
	velocity.y = jump_velocity

func set_velocity(inst_velocity: Vector2, direction: float = 1.0):
	velocity.x = direction * inst_velocity.x
	velocity.y = inst_velocity.y

func move_and_slide():
	if is_instance_valid(character):
		character.move_and_slide()
