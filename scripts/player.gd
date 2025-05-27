extends CharacterBody2D

@export var speed = 400 
@export var gravity = 1200 
@export var terminalVelocity = 1800
@export var jump_force = 1000
@export var ball_scene: PackedScene
@export var throw_force = Vector2(600, -400)


@onready var sprite: Sprite2D = $Sprite2D
@onready var animator : AnimationPlayer = $Sprite2D/AnimationPlayer




func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > terminalVelocity:
			velocity.y = terminalVelocity

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force 

	var hori_direction = Input.get_axis("move_left", "move_right")
	
	if hori_direction > 0:
		sprite.flip_h = false
	elif hori_direction <0:
		sprite.flip_h = true
	
	if Input.is_action_just_pressed("possess"):
		animator.play("throw")
		print("hi")
	if Input.is_action_just_released("possess"):
		animator.play("release")
		_throw_ball()
		

	velocity.x = speed * hori_direction  

	# Flip sprite depending on direction
	if hori_direction != 0:
		sprite.flip_h = hori_direction < 0

	move_and_slide()

func _throw_ball():
	if ball_scene:
		var ball = ball_scene.instantiate() as RigidBody2D
		var direction = 1
		if sprite.flip_h:
			direction = -1
		get_parent().add_child(ball)
		ball.global_position = global_position + Vector2(20 * direction, -10)
		ball.apply_impulse(Vector2(throw_force.x * direction, throw_force.y))
