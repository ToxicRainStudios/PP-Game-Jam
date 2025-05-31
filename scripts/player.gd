extends BaseCharacter2D

@export var ball_scene: PackedScene
@export var throw_strength: float = 800

@export var throw_texture: Texture2D
@export var powerdown_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $Sprite2D/AnimationPlayer

var current_ball: RigidBody2D = null
var direction = get_horizontal_input()


func _ready():
	sprite.region_enabled = true
	sprite.texture = throw_texture

func _physics_process(delta):
	var current_speed = speed

	if !Constants.possessed_something:
		update_movement(delta)  # inherited from base class
		
		# Get the global mouse position x
		var mouse_x = get_global_mouse_position().x
		
		# Flip sprite based on mouse position relative to the player
		if mouse_x > global_position.x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		
		# Your existing input handling
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
	else:
		if Input.is_action_just_released("unpossess"):
			print("waking back up")
			Constants.restore_camera_to_player()
			Constants.possessed_target._end_possession()
			animator.stop()
			sprite.texture = powerdown_texture
			Constants.play_sound_effect("res://sounds/luminousfridge__os-start.ogg")
			animator.play("powerup")
			Constants.possessed_something = false


func _throw_ball():
	if ball_scene:
		current_ball = ball_scene.instantiate() as RigidBody2D
		get_parent().add_child(current_ball)
		current_ball.global_position = global_position

		var mouse_pos = get_global_mouse_position()
		var impulse = (mouse_pos - current_ball.global_position).normalized() * throw_strength
		current_ball.apply_impulse(impulse)
