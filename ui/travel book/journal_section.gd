extends VBoxContainer

@onready var journal_things: CenterContainer = %JournalThings

func display():
	visible = true
	journal_things.visible = true

func conceal():
	visible = false
	journal_things.visible = false
