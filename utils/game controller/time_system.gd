extends Node
class_name TimeSystem

signal days_updated
signal hours_updated
signal minutes_updated
signal seconds_updated

@export var ticks_per_second: int = 30

@export_group("Current Time")
@export var days: int = 1:
	set(value):
		days = value
		days_updated.emit()
@export var hours: int = 0:
	set(value):
		hours = value
		hours_updated.emit()
@export var minutes: int = 0:
	set(value):
		minutes = value
		minutes_updated.emit()
@export var seconds: int = 0:
	set(value):
		seconds = value
		seconds_updated.emit()

var delta_time: float = 0.0

func _physics_process(delta: float) -> void:
	increase_time_by_sec(delta * ticks_per_second)
func increase_time_by_sec(delta_seconds: float) -> void:
	delta_time += delta_seconds
	if delta_time < 1.0: return
	
	var delta_in_secs = int(delta_time)
	delta_time -= delta_in_secs
	
	seconds += delta_in_secs
	
	if seconds >= 60:
		minutes += int(float(seconds) / 60)
		seconds = seconds % 60
	
	if minutes >= 60:
		hours += int(float(minutes) / 60)
		minutes = minutes % 60
	
	if hours >= 24:
		days += int(float(hours) / 24)
		hours = hours % 24
