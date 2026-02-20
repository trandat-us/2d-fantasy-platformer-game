extends SporelingState

@export var hurt_box_component: HurtBoxComponent
@export var vision_area: VisionArea

func enter() -> void:
	vision_area.enabled = false
	hurt_box_component.enabled = false
	animation_playback.travel("die")

func exit() -> void:
	vision_area.enabled = true
	hurt_box_component.enabled = true

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"die":
		sporeling.drop_loot_box()
		sporeling.revive()
