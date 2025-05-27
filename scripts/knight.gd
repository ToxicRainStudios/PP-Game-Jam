extends BaseCharacter2D

const SPEED = 60

var direct = 1
var is_possessed = false

@onready var ray_cast_left: RayCast2D = $RayCast2D2
@onready var ray_cast_right: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D

func _start_possession():
	is_possessed = true

func _physics_process(delta):
	var player = $"../../player"

	# Use inherited gravity
	apply_gravity(delta)

	if is_possessed:
		var input_dir = 0
		if Input.is_action_pressed("move_left"):
			input_dir -= 1
		if Input.is_action_pressed("move_right"):
			input_dir += 1

		velocity.x = input_dir * SPEED
		sprite.flip_h = input_dir < 0
	else:
		if ray_cast_right.is_colliding():
			if ray_cast_right.get_collider() == player:
				print("touching player")
			else:
				direct = -1
				sprite.flip_h = true

		if ray_cast_left.is_colliding():
			if ray_cast_left.get_collider() == player:
				print("touching player")
			else:
				direct = 1
				sprite.flip_h = false

		velocity.x = direct * SPEED

	move_and_slide()
