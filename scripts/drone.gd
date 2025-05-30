extends PossessableTarget2D

const SPEED = 60
const FLY_SPEED = 80

var direct = 1

func _physics_process(delta):
	if is_possessed:
		var input_dir_x = 0
		var input_dir_y = 0

		if Input.is_action_pressed("move_left"):
			input_dir_x -= 1
		if Input.is_action_pressed("move_right"):
			input_dir_x += 1
		if Input.is_action_pressed("jump"):
			input_dir_y -= 4

		# Flying ignores gravity
		velocity.x = input_dir_x * SPEED
		velocity.y = input_dir_y * FLY_SPEED
	else:
		velocity.x = direct * SPEED

	apply_gravity(delta)
	move_and_slide()
