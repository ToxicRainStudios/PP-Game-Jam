extends Node2D

const SPEED = 60

var direct = 1

@onready var ray_cast_left: RayCast2D = $RayCast2D2
@onready var ray_cast_right: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D


func _process(delta):
	if ray_cast_right.is_colliding():
		if (ray_cast_right.get_collider() == $"../../player"):
			print("touching player")
		else:
			direct = -1
			sprite.flip_h= true
	if ray_cast_left.is_colliding():
		if (ray_cast_left.get_collider() == $"../../player"):
			print("touching player")
		else:
			direct = 1
			sprite.flip_h= false
	
	position.x += direct* SPEED * delta
	
	
