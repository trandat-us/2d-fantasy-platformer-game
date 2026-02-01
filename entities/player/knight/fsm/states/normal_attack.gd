extends KnightState

@onready var combo_timer: Timer = $ComboTimer

@export var ground_state: KnightState
@export var melee_attack_component: MeleeAttackComponent

var next_attack: Dictionary = {
	"attack_1": "attack_2",
	"attack_2": "attack_3",
	"attack_3": "attack_1"
}
var current_attack: String

func enter():
	if current_attack.is_empty():
		current_attack = "attack_1"
	else:
		if not combo_timer.is_stopped():
			current_attack = next_attack[current_attack]
			combo_timer.stop()
	
	var damage = Damage.new()
	damage.amount = stats.normal_attack_damage
	damage.type = Damage.DamageType.REMOVAL
	
	melee_attack_component.damage = damage
	animation_playback.travel(current_attack)

func state_physics_process(delta: float):
	movement_component.stop_x_axis()
	movement_component.move_and_slide()

func _on_combo_timer_timeout() -> void:
	current_attack = "attack_1"

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == current_attack:
		state_transition.emit(self, ground_state)
		combo_timer.start()
