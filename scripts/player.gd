extends CharacterBody2D

@export var speed = 400 
@export var gravity = 1200 
@export var terminalVelocity = 1800
@export var jump_force = 1000
@export var ball_scene: PackedScene
@export var throw_strength = 800

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator : AnimationPlayer = $Sprite2D/AnimationPlayer



func _physics_process(delta):
	var speed2 = speed
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
		speed2 -= 100
	if Input.is_action_just_released("possess"):
		animator.play("release")
		_throw_ball()
		speed2 = speed
		

	velocity.x = speed2 * hori_direction  

	# Flip sprite depending on direction
	if hori_direction != 0:
		sprite.flip_h = hori_direction < 0

	move_and_slide()

func _throw_ball():
	if ball_scene:
		var ball = ball_scene.instantiate() as RigidBody2D
		get_parent().add_child(ball)
		ball.global_position = global_position
		
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - ball.global_position).normalized()
				
		var impulse = direction * throw_strength
		
		ball.apply_impulse(impulse)
