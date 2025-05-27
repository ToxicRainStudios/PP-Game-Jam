extends CharacterBody2D

@export var speed = 400 
@export var gravity = 1200 
@export var terminalVelocity = 1800
@export var jump_force = 1000
@export var ball_scene: PackedScene
@export var throw_strength = 800

@export var throw_texture: Texture2D
@export var powerdown_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $Sprite2D/AnimationPlayer

var current_ball: RigidBody2D = null  # Store reference to the thrown ball

func _ready():
	sprite.region_enabled = true
	sprite.texture = throw_texture # Set initial texture

func _physics_process(delta):
	var speed2 = speed
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > terminalVelocity:
			velocity.y = terminalVelocity
	
	if Constants.possessed_something == false:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -jump_force 

		var hori_direction = Input.get_axis("move_left", "move_right")
		
		if hori_direction > 0:
			sprite.flip_h = false
		elif hori_direction < 0:
			sprite.flip_h = true
		
		if Input.is_action_just_pressed("possess"):
			sprite.texture = throw_texture
			animator.play("throw")
			speed2 -= 100
			
		if Input.is_action_just_pressed("possess"):
			sprite.texture = throw_texture
			animator.play("throw")
			speed2 -= 100

		if Input.is_action_just_released("possess"):
			animator.play("release")
			_throw_ball()

			await get_tree().create_timer(1.0).timeout  # Wait a bit for possession logic to happen

			if Constants.possessed_something:
				print("got rizzed up, shutting down")
				animator.stop()
				sprite.texture = powerdown_texture
				animator.play("powerdown")

			speed2 = speed

		velocity.x = speed2 * hori_direction  
	move_and_slide()

func _throw_ball():
	if ball_scene:
		current_ball = ball_scene.instantiate() as RigidBody2D
		get_parent().add_child(current_ball)
		current_ball.global_position = global_position
		
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - current_ball.global_position).normalized()
		var impulse = direction * throw_strength
		
		current_ball.apply_impulse(impulse)
