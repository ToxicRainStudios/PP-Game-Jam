extends PossessableTarget2D

const SPEED = 60

var direct = 1


func _physics_process(delta):
	var player = $"../../player"

	apply_gravity(delta)

	if is_possessed:
		var input_dir = 0
		if Input.is_action_pressed("move_left"):
			input_dir -= 1
		if Input.is_action_pressed("move_right"):
			input_dir += 1

		velocity.x = input_dir * SPEED

	else:
	

		velocity.x = direct * SPEED

	move_and_slide()
