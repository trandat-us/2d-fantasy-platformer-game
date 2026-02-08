extends Button

@onready var normal_texture: NinePatchRect = $NormalTexture
@onready var focused_texture: NinePatchRect = $FocusedTexture

func _on_focus_entered() -> void:
	normal_texture.visible = false
	focused_texture.visible = true

func _on_focus_exited() -> void:
	normal_texture.visible = true
	focused_texture.visible = false
