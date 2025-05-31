extends PossessableTarget2D

const SPEED = 60
const FLY_SPEED = 80
const CIRCLE_RADIUS = 50
const CIRCLE_SPEED = 1.5  # radians per second
const ACCELERATION = 200  # tweak this for smoothness
const MIN_DISTANCE_TO_PLAYER = 20

@onready var raycast = $RayCast2D

var angle := 0.0
var center := Vector2.ZERO
var player_detected := false

func _ready():
	center = global_position  # initial center of the circle
	raycast.enabled = true

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

		velocity.x = input_dir_x * SPEED
		velocity.y = input_dir_y * FLY_SPEED
		player_detected = false  # reset when possessed
	else:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.name == "player":
				if not player_detected:
					# Player just detected, set center to player's position to avoid reset jitter
					center = collider.global_position
					player_detected = true
				var player_pos = collider.global_position
				var to_player = player_pos - global_position
				var distance = to_player.length()
				
				if distance > MIN_DISTANCE_TO_PLAYER:
					# Move smoothly toward player
					var direction = to_player.normalized()
					# Accelerate velocity towards desired velocity
					var desired_velocity = direction * FLY_SPEED
					velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
				else:
					# Close enough to player, slow down to stop to avoid jitter
					velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
			else:
				# No player detected
				if player_detected:
					# Player lost, reset orbit center to current position
					center = global_position
					player_detected = false

				# Continue circling
				angle += CIRCLE_SPEED * delta
				var offset = Vector2(
					cos(angle),
					sin(angle)
				) * CIRCLE_RADIUS

				var desired_pos = center + offset
				var desired_velocity = (desired_pos - global_position) / delta
				velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
		else:
			# No collision, keep circling
			if player_detected:
				# Player lost, reset orbit center
				center = global_position
				player_detected = false

			angle += CIRCLE_SPEED * delta
			var offset = Vector2(
				cos(angle),
				sin(angle)
			) * CIRCLE_RADIUS

			var desired_pos = center + offset
			var desired_velocity = (desired_pos - global_position) / delta
			velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)

	move_and_slide()
