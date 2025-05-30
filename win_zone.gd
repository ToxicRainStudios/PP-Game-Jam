extends Node2D

@onready var area = $Area2D

@export var target_node_path: NodePath
@export var next_scene_path: String = "res://NextLevel.tscn"  # Set this to the path of your next level scene

@onready var vapor_shader_rect: ColorRect = $VaporEffect/ColorRect

var target_node: Node2D
var has_won := false
var vapor_material: ShaderMaterial

func _ready():
	target_node = get_node_or_null(target_node_path)
	vapor_material = vapor_shader_rect.material
	
	# Start hidden
	vapor_shader_rect.visible = false

func _process(_delta):
	if not has_won and target_node and is_inside_area(target_node.global_position):
		print("Detected inside area:", target_node.name)
		on_win()

func is_inside_area(world_pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = world_pos
	query.collide_with_bodies = false
	query.collide_with_areas = true
	query.collision_mask = area.collision_layer
	
	var results = space_state.intersect_point(query)
	for result in results:
		if result.collider == area:
			return true
	return false

func on_win():
	has_won = true
	print("WIN TRIGGERED")
	Constants.play_sound_effect("res://sounds/theeinfernalpractice__winlevel1.wav")

	# Resize the shader rect to cover the screen
	var screen_rect = get_viewport_rect()
	vapor_shader_rect.position = Vector2.ZERO
	vapor_shader_rect.size = screen_rect.size
	vapor_shader_rect.visible = true

	# Animate shader
	vapor_material.set_shader_parameter("intensity", 0.0)
	var tween = create_tween()
	tween.tween_property(vapor_material, "shader_parameter/intensity", 1.0, 4.0)

	await get_tree().create_timer(4.0).timeout
	get_tree().change_scene_to_file(next_scene_path)
