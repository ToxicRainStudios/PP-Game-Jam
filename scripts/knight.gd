extends PossessableTarget2D

var direct = 1
var animation_finished = true

@onready var ray_cast_left: RayCast2D = $RayCast2D2
@onready var ray_cast_right: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var Animator: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var swing_area = $"Swing Area"
	
func _swing():
	velocity.x = 0
	animation_finished = false
	print("starting swing")
	Animator.play("swing")
	swing_area.apply_scale(Vector2(2,1))
	

func _physics_process(delta):
	var player = $"../../player"

	apply_gravity(delta)

	if not animation_finished:
		velocity.x = 0
	elif is_possessed:
		$"Swing Area/Death Zone".is_live = false
		var input_dir = 0
		if Input.is_action_pressed("move_left"):
			input_dir -= 1
		if Input.is_action_pressed("move_right"):
			input_dir += 1
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = -jump_force

		velocity.x = input_dir * speed
		sprite.flip_h = input_dir < 0
		swing_area.position.x = 30 if not sprite.flip_h else -30  # flip swing area too

		# Handle swing input
		if Input.is_action_just_pressed("possess"):
			_swing()
	else:
		$"Swing Area/Death Zone".is_live = true
		if ray_cast_right.is_colliding():
			if ray_cast_right.get_collider() == player:
				swing_area.position.x = 30
				sprite.flip_h = false
				_swing()
				direct = 1
			else:
				sprite.flip_h = true
				direct = -1
		elif ray_cast_left.is_colliding():
			if ray_cast_left.get_collider() == player:
				swing_area.position.x = -30
				sprite.flip_h = true
				_swing()
				direct = -1
			else:
				sprite.flip_h = false
				direct = 1

		velocity.x = direct * speed

	move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "swing":
		swing_area.apply_scale(Vector2(0,0))
		print("finished anim")
		animation_finished = true
