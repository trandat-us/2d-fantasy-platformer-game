extends CharacterBody2D
class_name NPC

@onready var pivot: Node2D = $Pivot
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactive_component: InteractiveComponent = $InteractiveComponent

@export var npc_name: String

var event_bus: EventBus
var default_collision_position_x: float
var direction: float = 1.0:
	set(value):
		direction = signf(value)
		_update_facing_direction()

func _ready() -> void:
	event_bus = get_tree().get_first_node_in_group("event_bus")
	default_collision_position_x = collision_shape_2d.position.x
	interactive_component.interact = _on_interact

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_interact(interactor: Node2D):
	pass

func _update_facing_direction():
	if direction == 1.0:
		pivot.scale.x = 1.0
		collision_shape_2d.position.x = default_collision_position_x
		interactive_component.scale.x = 1.0
	elif direction == -1.0:
		pivot.scale.x = -1.0
		collision_shape_2d.position.x = -default_collision_position_x
		interactive_component.scale.x = -1.0
