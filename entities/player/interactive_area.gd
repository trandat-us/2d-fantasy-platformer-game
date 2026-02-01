extends Area2D

@export var player: Player

var interactable_objects: Array[InteractiveComponent] = []

func _process(delta: float) -> void:
	if interactable_objects:
		interactable_objects.sort_custom(_sort_by_nearest)

func _sort_by_nearest(area_1: Area2D, area_2: Area2D):
	var area_1_dist = global_position.distance_to(area_1.global_position)
	var area_2_dist = global_position.distance_to(area_2.global_position)
	return area_1_dist < area_2_dist

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player.input_enabled:
		if interactable_objects:
			interactable_objects[0].interact.call(player)

func _on_area_entered(area: Area2D) -> void:
	if area is InteractiveComponent:
		interactable_objects.append(area)
		area.show_hint.call()

func _on_area_exited(area: Area2D) -> void:
	if area is InteractiveComponent:
		interactable_objects.erase(area)
		area.hide_hint.call()
