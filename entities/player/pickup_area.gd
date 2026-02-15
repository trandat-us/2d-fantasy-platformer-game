extends Area2D

@export var player: Player

func _on_area_entered(area: Area2D) -> void:
	if not player:
		return
	
	var parent = area.get_parent()
	if not parent is Collectible:
		return
	
	player.inventory.add_item(parent.item, parent.amount)
	parent.queue_free()
