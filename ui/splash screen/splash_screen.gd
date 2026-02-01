extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("show")
	await animation_player.animation_finished
	SceneManager.change_to_scene_file(
		"res://ui/menus/main/main_menu.tscn", 
		self, 
		null,
		SceneManager.SceneTransitionType.FADE
	)
