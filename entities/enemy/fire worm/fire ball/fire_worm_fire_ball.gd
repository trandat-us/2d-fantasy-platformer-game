extends Area2D
class_name FireWormFireBall

@onready var live_timer: Timer = $LiveTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var lifetime: float = 3.0
@export var speed: float = 300.0
@export var direction: Vector2 = Vector2.RIGHT

var attack: Attack

func _ready() -> void:
	rotation = direction.angle()
	live_timer.wait_time = lifetime
	live_timer.start()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _explode():
	speed = 0.0
	animation_player.play("explode")
	await animation_player.animation_finished
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxComponent:
		_explode()
		
		if is_instance_valid(attack):
			attack.attack_direction = signf(area.global_position.x - global_position.x)
			area.get_hurt.call(attack)

func _on_live_timer_timeout() -> void:
	_explode()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		return
	
	_explode()
