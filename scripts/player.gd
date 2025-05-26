extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var terminalVelocity = 600
@export var jump_force = 300

func _physics_process(delta):
	if !is_on_floor(): ## apply gravity
		velocity.y += gravity
		if velocity.y > terminalVelocity:
				velocity.y = terminalVelocity
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = - jump_force
	
	## move left and right
	var hori_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * hori_direction

	move_and_slide()
	print(velocity)
