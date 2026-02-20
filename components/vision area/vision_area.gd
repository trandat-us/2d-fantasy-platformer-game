@tool
extends Area2D
class_name VisionArea

signal target_detected(target: Node2D)
signal target_undetected

@onready var detectors_pivot: Node2D = $DetectorsPivot

@export var enabled: bool = true:
	set(value):
		enabled = value
		if is_node_ready():
			if _collision_node:
				_collision_node.set_deferred("disabled", !enabled)
			
			if not enabled:
				cleanup()
@export_range(1, 1000000, 1, "hide_control", "or_greater") var number_of_detectors: int = 3
@export_range(0, 360, 0.01, "degrees") var angle_between_detectors: float = 3.0:
	get:
		if Engine.is_editor_hint():
			return angle_between_detectors
		return deg_to_rad(angle_between_detectors)
@export_range(0.01, 1000000, 0.01, "hide_control", "or_greater", "suffix:px") var detector_range: float = 400.0

var target: Node2D

var _collision_node: Node2D
var _target_inside_vision_area: bool = false
var _detectors: Array[RayCast2D] = []

func cleanup():
	target = null
	_free_detectors()

func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	_handle_detectors_direction()
	
	if _is_detected_target():
		target_detected.emit(target)
	else:
		if not _target_inside_vision_area:
			cleanup()
		target_undetected.emit()

func _handle_detectors_direction():
	var target_direction = detectors_pivot.global_position.direction_to(target.global_position)
	var target_angle = target_direction.angle()
	
	var total_angle = angle_between_detectors * (number_of_detectors - 1)
	var start_angle = target_angle - total_angle / 2.0
	
	for i in range(_detectors.size()):
		var detector = _detectors[i]
		var angle = start_angle + (i * angle_between_detectors)
		
		detector.target_position = Vector2(cos(angle), sin(angle)) * detector_range

func _is_detected_target():
	for detector in _detectors:
		if detector.is_colliding() and detector.get_collider() == target:
			return true
	return false

func _generate_detectors():
	_free_detectors()
	
	var target_direction = detectors_pivot.global_position.direction_to(target.global_position)
	var target_angle = target_direction.angle()
	
	var total_angle = angle_between_detectors * (number_of_detectors - 1)
	var start_angle = target_angle - total_angle / 2.0
	
	for i in range(number_of_detectors):
		var raycast = RayCast2D.new()
		raycast.collision_mask = collision_mask
		raycast.hit_from_inside = true
		
		var angle = start_angle + (i * angle_between_detectors)
		raycast.target_position = Vector2(cos(angle), sin(angle)) * detector_range
		
		detectors_pivot.add_child(raycast)
		_detectors.append(raycast)

func _free_detectors():
	for detector in detectors_pivot.get_children():
		detector.queue_free()
	_detectors.clear()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if target == null:
			target = body
			_generate_detectors()
		_target_inside_vision_area = true

func _on_body_exited(body: Node2D) -> void:
	if body == target:
		_target_inside_vision_area = false

func _on_child_entered_tree(node: Node) -> void:
	if (node is CollisionShape2D or node is CollisionPolygon2D) and _collision_node == null:
		_collision_node = node

func _on_child_exiting_tree(node: Node) -> void:
	if node == _collision_node:
		_collision_node = null
