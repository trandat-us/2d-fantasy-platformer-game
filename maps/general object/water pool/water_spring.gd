extends Node2D
class_name WaterSpring

var velocity: float = 0.0
var initial_height: float
var current_height: float:
	get: return position.y

func _ready() -> void:
	initial_height = position.y
	modulate.a = 0

func update_position(k: float = 0.015, d: float = 0.03) -> void:
	var x: float = current_height - initial_height
	var loss: float = -d * velocity 
	var force: float = -k * x + loss
	velocity += force
	position.y += velocity
