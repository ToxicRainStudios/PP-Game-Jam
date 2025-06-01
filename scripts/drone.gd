extends PossessableTarget2D

const SPEED = 60
const FLY_SPEED = 80
const CIRCLE_RADIUS = 50
const CIRCLE_SPEED = 1.5  # radians per second
const ACCELERATION = 200
const MIN_DISTANCE_TO_PLAYER = 20

@onready var raycast = $RayCast2D

var angle := 0.0
var center := Vector2.ZERO
var player_detected := false

var grabbed_body: Node2D = null
var grab_joint: PinJoint2D = null
var grabbed_body_original_rotation := 0.0

var proxy: RigidBody2D = null

func _ready():
	center = global_position
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

		if Input.is_action_just_pressed("possess"):
			if raycast.is_colliding():
				var body = raycast.get_collider()
				if body is CharacterBody2D:
					grabbed_body = body
					grabbed_body_original_rotation = body.global_rotation  
					_create_proxy_for_character(body)
					
					body.set_physics_process(false)
					#body.hide()
					
					grab_joint = PinJoint2D.new()
					grab_joint.position = raycast.get_collision_point()
					grab_joint.node_a = get_path()
					grab_joint.node_b = proxy.get_path()
					get_tree().current_scene.add_child(grab_joint)
				elif body is RigidBody2D:
					grabbed_body = body
					grab_joint = PinJoint2D.new()
					grab_joint.position = raycast.get_collision_point()
					grab_joint.node_a = get_path()
					grab_joint.node_b = body.get_path()
					get_tree().current_scene.add_child(grab_joint)
		elif Input.is_action_just_released("possess"):
			_release_grabbed_body()

		velocity.x = input_dir_x * SPEED
		velocity.y = input_dir_y * FLY_SPEED
		player_detected = false
		
		if grabbed_body and grabbed_body is CharacterBody2D and proxy:
			grabbed_body.global_position = proxy.global_position
			grabbed_body.global_rotation = proxy.global_rotation
			
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			# on floor, no gravity effect
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

func _create_proxy_for_character(character):
	if proxy:
		return

	proxy = RigidBody2D.new()
	proxy.global_position = character.global_position
	proxy.global_rotation = character.global_rotation

	var shape_node = character.get_node_or_null("CollisionShape2D")
	if shape_node and shape_node.shape:
		var proxy_shape = CollisionShape2D.new()
		proxy_shape.shape = shape_node.shape.duplicate()
		proxy.add_child(proxy_shape)

	get_parent().add_child(proxy)

func _release_grabbed_body():
	if grab_joint and grab_joint.get_parent():
		grab_joint.queue_free()
		grab_joint = null
		
	if grabbed_body:
		if grabbed_body is CharacterBody2D:
			grabbed_body.show()
			grabbed_body.set_physics_process(true)
			grabbed_body.global_rotation = grabbed_body_original_rotation  # Reset rotation
		grabbed_body = null
		
	if proxy and proxy.is_inside_tree():
		proxy.queue_free()
	proxy = null
