@tool
extends StaticBody2D

@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _platform_width := 200.0
@export var platform_width: float:
	get: return _platform_width
	set(value):
		_platform_width = value
		_update_platform()

var _platform_height := 40.0
@export var platform_height: float:
	get: return _platform_height
	set(value):
		_platform_height = value
		_update_platform()

var _platform_color := Color(0.4, 0.4, 1.0)
@export var platform_color: Color:
	get: return _platform_color
	set(value):
		_platform_color = value
		_update_platform()

func _ready():
	_update_platform()

func _update_platform():
	var size = Vector2(platform_width, platform_height)

	# Update ColorRect
	if color_rect:
		color_rect.size = size
		color_rect.position = Vector2.ZERO  # Make sure it aligns correctly
		color_rect.color = platform_color

	# Update or create RectangleShape2D
	if collision_shape:
		if collision_shape.shape == null or not collision_shape.shape is RectangleShape2D:
			collision_shape.shape = RectangleShape2D.new()

		var shape := collision_shape.shape as RectangleShape2D
		shape.extents = size * 0.5
		collision_shape.position = size * 0.5  # Align the shape with the visual
