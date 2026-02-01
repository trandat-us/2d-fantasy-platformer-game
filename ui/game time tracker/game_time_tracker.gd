extends Control
class_name GameTimeTracker

@onready var time_label: Label = $Panel/TimeLabel

@export var time_system: TimeSystem

func _ready() -> void:
	if is_instance_valid(time_system):
		time_system.hours_updated.connect(_update_hours)
		time_system.minutes_updated.connect(_update_minutes)
		
		_update_hours()
		_update_minutes()

func _get_number_string(number: int) -> String:
	var number_str = str(number)
	if number_str.length() == 1:
		number_str = "0" + number_str
	
	return number_str

func _update_hours() -> void:
	time_label.text = _get_number_string(time_system.hours) + " : " + _get_number_string(time_system.minutes)

func _update_minutes() -> void:
	time_label.text = _get_number_string(time_system.hours) + " : " + _get_number_string(time_system.minutes)
