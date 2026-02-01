extends Node
class_name EventBus

signal player_revived
signal player_died
signal player_health_changed(current_health: int, max_health: int)
