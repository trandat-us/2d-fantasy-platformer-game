@tool
extends Resource
class_name Damage

enum DamageType { 
	REMOVAL, 
	DEATHBLOW 
}

@export var type: DamageType = DamageType.REMOVAL:
	set(value):
		type = value
		notify_property_list_changed()
var amount: int = 1

func _init(_amount: int = 1, _type: DamageType = DamageType.REMOVAL) -> void:
	amount = _amount
	type = _type

func _get_property_list():
	var ret = []
	
	if Engine.is_editor_hint():
		if type == DamageType.REMOVAL:
			ret.append({
				"name": &"amount",
				"type": TYPE_INT,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint_string": "1, 1000, or_greater",
				"hint": PROPERTY_HINT_RANGE
			})
	
	return ret
