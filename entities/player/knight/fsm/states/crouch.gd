extends KnightState

@export var ground_state: KnightState
@export var fall_state: KnightState

@export var default_c_shape: CollisionShape2D
@export var default_hurt_box: CollisionShape2D
@export var crouch_c_shape: CollisionShape2D
@export var crouch_hurt_box: CollisionShape2D
@export var above_ground_detector: RayCast2D

var axis: float
var can_move: bool
var blend_animation = "parameters/crouch/blend_position"

func enter():
	can_move = false
	animation_playback.travel("enter_crouching")

func exit():
	_disable_crouch_collision()

func state_process(delta: float):
	animation_tree.set(blend_animation, axis)

func state_physics_process(delta: float):
	if not knight.is_on_floor():
		state_transition.emit(self, fall_state)
		return
		
	if Input.is_action_just_pressed("crouch") and not above_ground_detector.is_colliding():
		state_transition.emit(self, ground_state)
		return
	
	axis = knight.check_horizontal_movement_input()
	if axis and can_move:
		movement_component.move_x_axis(stats.crouch_speed, axis)
	else:
		movement_component.stop_x_axis()
	movement_component.move_and_slide()

func _enable_crouch_collision():
	above_ground_detector.enabled = true
	default_c_shape.set_deferred("disabled", true)
	default_hurt_box.set_deferred("disabled", true)
	crouch_c_shape.set_deferred("disabled", false)
	crouch_hurt_box.set_deferred("disabled", false)

func _disable_crouch_collision():
	above_ground_detector.enabled = false
	default_c_shape.set_deferred("disabled", false)
	default_hurt_box.set_deferred("disabled", false)
	crouch_c_shape.set_deferred("disabled", true)
	crouch_hurt_box.set_deferred("disabled", true)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter_crouching":
		can_move = true
		_enable_crouch_collision()
