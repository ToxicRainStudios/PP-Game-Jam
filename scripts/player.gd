extends CharacterBody2D

@export var speed = 400 
@export var gravity = 1200 
@export var terminalVelocity = 1800
@export var jump_force = 16000

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > terminalVelocity:
			velocity.y = terminalVelocity

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

	var hori_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * hori_direction  

	move_and_slide()
