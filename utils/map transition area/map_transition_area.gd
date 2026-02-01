extends Area2D
class_name MapTransitionArea

@export var current_map: Map
@export var target_map: String
@export var trans_type: SceneManager.SceneTransitionType = SceneManager.SceneTransitionType.FADE

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		set_deferred("monitoring", false) 
		
		var handoff_data = current_map.get_handoff_data() if current_map.has_method("get_handoff_data") else null
		SceneManager.change_to_scene_file(target_map, current_map, handoff_data, trans_type)
