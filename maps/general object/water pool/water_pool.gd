@tool
extends Polygon2D
class_name WaterPool

const WATER_SPRING = preload("uid://bs4kbl7hsfldw")

@onready var spring_pivot: Node2D = $SpringPivot
@onready var collision_area: Area2D = $CollisionArea
@onready var collision_shape_2d: CollisionShape2D = $CollisionArea/CollisionShape2D

@export_group("Spring Force", "spring_")
@export_range(0.001, 1000000, 0.001, "hide_control", "or_greater") var spring_constant: float = 0.015
@export_range(0.001, 1000000, 0.001, "hide_control", "or_greater") var spring_dampening: float = 0.03
@export_group("Spring Config")
@export_range(1, 1000000, 1, "hide_control", "or_greater") var number_of_springs: int = 5:
	set(value):
		number_of_springs = value
		if is_node_ready():
			_initialize_springs()
			_update_visual()
			_update_collision_area()
@export_range(1, 1000000, 1, "or_greater", "hide_control", "suffix:px") var distance_between_spring: int = 32:
	set(value):
		distance_between_spring = value
		if is_node_ready():
			_initialize_springs()
			_update_visual()
			_update_collision_area()
@export_range(0, 1000000, 1, "or_greater", "hide_control") var points_between_spring: int = 40:
	set(value):
		points_between_spring = value
		if is_node_ready():
			_update_visual()
@export_range(1, 1000000, 1, "hide_control", "or_greater", "suffix:px") var depth: int = 32:
	set(value):
		depth = value
		if is_node_ready():
			_update_visual()
			_update_collision_area()
@export_range(1, 1000000, 1, "hide_control", "or_greater") var spread: float = 2
@export_range(1, 1000000, 1, "hide_control", "or_greater") var passes: int = 8
@export_range(1, 1000000, 1, "hide_control", "or_greater") var splash_force: int = 4

var springs: Array[WaterSpring]
var total_distance: int:
	get: return distance_between_spring * (number_of_springs - 1)

func _ready() -> void:
	_initialize_springs()
	_update_visual()
	_update_collision_area()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	for i in range(number_of_springs):
		if i == 0 or i == number_of_springs - 1:
			continue
		springs[i].update_position(spring_constant, spring_dampening)
	_spread_waves()
	_update_visual()

func _spread_waves() -> void:
	var left_deltas: Array[float] = []
	var right_deltas: Array[float] = []
	
	left_deltas.resize(number_of_springs)
	right_deltas.resize(number_of_springs)
	left_deltas.fill(0.0)
	right_deltas.fill(0.0)
	
	for __ in range(passes):
		for i in range(number_of_springs):
			if i > 0:
				left_deltas[i] = (spread / 1000) * (springs[i].current_height - springs[i - 1].current_height)
				springs[i - 1].velocity += left_deltas[i]
			if i < number_of_springs - 1:
				right_deltas[i] = (spread / 1000) * (springs[i].current_height - springs[i + 1].current_height)
				springs[i + 1].velocity += right_deltas[i]

func _initialize_springs() -> void:
	for spring in spring_pivot.get_children():
		spring.queue_free()
	springs.clear()
	
	var start_pos := -total_distance * 0.5
	
	for i in range(number_of_springs):
		var spring: WaterSpring = WATER_SPRING.instantiate()
		spring_pivot.add_child(spring)
		springs.append(spring)
		spring.position.x = start_pos + i * distance_between_spring
		spring.owner = get_tree().edited_scene_root

func _update_visual() -> void:
	var polygon_points: PackedVector2Array = []
	var uv_points: PackedVector2Array = []
	
	for i in range(number_of_springs):
		if i == number_of_springs - 1:
			polygon_points.append(springs[i].position)
		else:
			polygon_points.append(springs[i].position)
			var smooth_points = _get_smooth_points_between(springs[i].position, springs[i + 1].position)
			for point in smooth_points:
				polygon_points.append(point)
	
	var edge_size = polygon_points.size()
	for i in range(edge_size):
		uv_points.append(Vector2(float(i) / edge_size, 0.0))
	
	polygon_points.append(Vector2(springs[-1].position.x, depth))
	polygon_points.append(Vector2(springs[0].position.x, depth))
	uv_points.append(Vector2(1.0, 1.0))
	uv_points.append(Vector2(0.0, 1.0))
	
	polygon = polygon_points
	uv = uv_points

func _update_collision_area() -> void:
	collision_shape_2d.shape.size = Vector2(total_distance, depth)
	collision_shape_2d.position.y = depth * 0.5

# Note: this only return subpoints between from and to, doesn't include from and to vector
func _get_smooth_points_between(vec_from: Vector2, vec_to: Vector2) -> Array[Vector2]:
	var smooth_points: Array[Vector2] = []
	for i in range(points_between_spring):
		var t = float(i) / points_between_spring
		var smooth_t = smoothstep(0.0, 1.0, t)
		
		smooth_points.append(Vector2(
			lerp(vec_from.x, vec_to.x, t),          
			lerp(vec_from.y, vec_to.y, smooth_t)  
		))
	smooth_points.pop_front()
	return smooth_points

func _get_splash_index(local_pos: Vector2) -> int:
	var idx_dst = round(local_pos.x / distance_between_spring)
	var index: int
	if number_of_springs % 2 == 0:
		if idx_dst > 0:
			index = number_of_springs * 0.5 + idx_dst
		else:
			index = number_of_springs * 0.5 - 1 + idx_dst
	else:
		index = (number_of_springs - 1) * 0.5 + idx_dst
	
	if index == 0:
		index += 1
	elif index == number_of_springs - 1:
		index -= 1
	
	return index

func _on_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.05).timeout
	var local_pos := to_local(body.global_position)
	splash(_get_splash_index(local_pos), splash_force)

func _on_body_exited(body: Node2D) -> void:
	var local_pos := to_local(body.global_position)
	splash(_get_splash_index(local_pos), -splash_force)

func splash(index: int, speed: float) -> void:
	if index < 1 or index >= number_of_springs - 1:
		push_warning("Splash index out of bounds: " + str(index))
		return
	springs[index].velocity += speed
