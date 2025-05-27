extends BaseCharacter2D

@export var ball_scene: PackedScene
@export var throw_strength: float = 800

@export var throw_texture: Texture2D
@export var powerdown_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $Sprite2D/AnimationPlayer

var current_ball: RigidBody2D = null

func _ready():
	sprite.region_enabled = true
	sprite.texture = throw_texture

func _physics_process(delta):
	var current_speed = speed

	if !Constants.possessed_something:
		update_movement(delta)  # inherited from base class

		var direction = get_horizontal_input()
		if direction > 0:
			sprite.flip_h = false
		elif direction < 0:
			sprite.flip_h = true
	
		if Input.is_action_just_pressed("possess"):
			sprite.texture = throw_texture
			animator.play("throw")
			current_speed -= 100

		if Input.is_action_just_released("possess"):
			animator.play("release")
			_throw_ball()

			await get_tree().create_timer(1.0).timeout

			if Constants.possessed_something:
				print("got rizzed up, shutting down")
				animator.stop()
				sprite.texture = powerdown_texture
				animator.play("powerdown")

		velocity.x = direction * current_speed

func _throw_ball():
	if ball_scene:
		current_ball = ball_scene.instantiate() as RigidBody2D
		get_parent().add_child(current_ball)
		current_ball.global_position = global_position

		var mouse_pos = get_global_mouse_position()
		var impulse = (mouse_pos - current_ball.global_position).normalized() * throw_strength
		current_ball.apply_impulse(impulse)
