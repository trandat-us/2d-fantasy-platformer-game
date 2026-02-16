extends Camera2D

@onready var blood_screen_ani_player: AnimationPlayer = $BloodScreen/AnimationPlayer

func reset():
	blood_screen_ani_player.play("RESET")

func show_and_hide_blood_screen():
	blood_screen_ani_player.seek(0)
	blood_screen_ani_player.play("show_and_hide")

func show_blood_screen():
	blood_screen_ani_player.seek(0)
	blood_screen_ani_player.play("show")
