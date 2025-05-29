extends CharacterBody2D
class_name BaseCharacter2D

@export var speed: float = 400
@export var gravity: float = 1200
@export var terminal_velocity: float = 1800
@export var jump_force: float = 1000
@export var has_jump: bool = false

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, terminal_velocity)

func handle_jump() -> void:
	if has_jump and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

func get_horizontal_input() -> float:
	return Input.get_axis("move_left", "move_right")

func update_movement(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()

	var direction = get_horizontal_input()
	velocity.x = direction * speed

	move_and_slide()
