extends FireWormState

@export var hurt_box_component: HurtBoxComponent

func enter():
	animation_playback.travel("die")
	hurt_box_component.enabled = false

func exit() -> void:
	hurt_box_component.enabled = true

func state_physics_process(delta: float):
	movement_component.apply_gravity(delta)
	movement_component.stop_x_axis()
	movement_component.move_and_slide()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		fire_worm.drop_loot_box()
		fire_worm.revive()
