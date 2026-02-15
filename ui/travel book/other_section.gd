extends CenterContainer

@onready var other_things: CenterContainer = %OtherThings

func display():
	visible = true
	other_things.visible = true

func conceal():
	visible = false
	other_things.visible = false
