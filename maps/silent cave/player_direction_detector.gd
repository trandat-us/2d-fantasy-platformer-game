extends Area2D

signal player_go_to_right
signal player_go_to_left

func _on_body_exited(body: Node2D) -> void:
	var _exit_direction = sign(body.global_position.x - global_position.x)
	if _exit_direction == 1:
		player_go_to_right.emit()
	elif _exit_direction == -1:
		player_go_to_left.emit()
