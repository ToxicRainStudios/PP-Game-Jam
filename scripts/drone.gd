extends PossessableTarget2D

const FLY_SPEED = 80
const CIRCLE_RADIUS = 50
const CIRCLE_SPEED = 1.5
const ACCELERATION = 200
const MIN_DISTANCE_TO_PLAYER = 20

@onready var raycast = $RayCast2D
@onready var drag_controller = DragHandler.new()

var angle := 0.0
var center := Vector2.ZERO
var player_detected := false

func _ready():
	center = global_position
	raycast.enabled = true
	add_child(drag_controller)

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

		if Input.is_action_just_pressed("possess"):
			$"Death Zone".is_live = false
			drag_controller.grab(self, raycast, get_tree().current_scene)

		elif Input.is_action_just_released("possess"):
			$"Death Zone".is_live = false
			drag_controller.release()

		velocity.x = input_dir_x * speed
		velocity.y = input_dir_y * FLY_SPEED
		player_detected = false

		drag_controller.update_grabbed_transform()

		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0 if velocity.y > 0 else velocity.y

	else:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is CharacterBody2D and collider.name == "player":
				if not player_detected:
					center = collider.global_position
					player_detected = true

				var to_player = collider.global_position - global_position
				var distance = to_player.length()

				if distance > MIN_DISTANCE_TO_PLAYER:
					var direction = to_player.normalized()
					var desired_velocity = direction * FLY_SPEED
					velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
				else:
					velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
			else:
				_handle_circle_orbit(delta)
		else:
			_handle_circle_orbit(delta)

	move_and_slide()

func _handle_circle_orbit(delta):
	if player_detected:
		center = global_position
		player_detected = false

	angle += CIRCLE_SPEED * delta
	var offset = Vector2(cos(angle), sin(angle)) * CIRCLE_RADIUS
	var desired_pos = center + offset
	var desired_velocity = (desired_pos - global_position) / delta
	velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
