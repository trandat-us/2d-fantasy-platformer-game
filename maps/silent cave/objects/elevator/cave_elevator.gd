@tool
extends Path2D

const SPRITE_SCENE = preload("res://maps/silent cave/objects/elevator/cave_elevator_sprite.tscn")

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var platform: Node2D = $AnimatableBody2D/Platform
@onready var collision_shape_2d: CollisionShape2D = $AnimatableBody2D/CollisionShape2D

@export var run_in_editor: bool = false:
	set(value):
		run_in_editor = value
		if is_node_ready():
			_reset_position()
			if run_in_editor:
				_make_moving()
@export var moving_duration: float = 3.0:
	set(value):
		moving_duration = max(0.0, value)
		if is_node_ready():
			_reset_position()
			if run_in_editor:
				_make_moving()
@export var rest_duration: float = 3.0:
	set(value):
		rest_duration = max(0.0, value)
		if is_node_ready():
			_reset_position()
			if run_in_editor:
				_make_moving()
@export var number_of_sprites: int = 1:
	set(value):
		number_of_sprites = max(1, value)
		if is_node_ready():
			_adjust_platform()

var _sprite_width: float = 48.0
var _moving_tween: Tween

func _ready() -> void:
	_adjust_platform()
	_reset_position()
	
	if not Engine.is_editor_hint():
		_make_moving()

func _make_moving():
	_moving_tween = create_tween().set_loops(0).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	_moving_tween.tween_property(path_follow_2d, "progress_ratio", 1.0, moving_duration) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_SINE)
	_moving_tween.tween_interval(rest_duration)
	_moving_tween.tween_property(path_follow_2d, "progress_ratio", 0.0, moving_duration) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_SINE)
	_moving_tween.tween_interval(rest_duration)

func _reset_position():
	if _moving_tween and _moving_tween.is_running():
		_moving_tween.kill()
	
	path_follow_2d.progress_ratio = 0.0

func _adjust_platform():
	var total_width = _sprite_width * number_of_sprites
	var start_position = (-total_width  + _sprite_width) / 2
	
	for child in platform.get_children():
		child.queue_free()
	
	for i in range(number_of_sprites):
		var new_sprite = SPRITE_SCENE.instantiate()
		var final_postion = start_position + i * _sprite_width
		platform.add_child(new_sprite)
		
		new_sprite.position = Vector2(final_postion, 0.0)
		new_sprite.owner = get_tree().edited_scene_root
	
	collision_shape_2d.shape.size.x = total_width
