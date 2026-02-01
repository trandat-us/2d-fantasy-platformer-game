@tool
extends Node2D
class_name LevelBounds

@export_group("Shape Size")
@export_range(1, 1000000, 1, "suffix:px", "or_greater") var width: int = 1152:
	set(value):
		width = value
		queue_redraw()
@export_range(1, 1000000, 1, "suffix:px", "or_greater") var height: int = 648:
	set(value):
		height = value
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		var rect := Rect2(Vector2.ZERO, Vector2(width, height))
		draw_rect(rect, Color(1.0, 0.0, 0.0, 0.75), false, 3)

func set_camera_limits():
	var camera: Camera2D = get_viewport().get_camera_2d()
	
	if not camera:
		await get_tree().process_frame
		camera = get_viewport().get_camera_2d()
	
	if not camera:
		push_warning("LevelBounds: No camera found in viewport")
		return
	
	camera.limit_left = int(global_position.x)
	camera.limit_top = int(global_position.y)
	camera.limit_right = int(global_position.x) + width
	camera.limit_bottom = int(global_position.y) + height
