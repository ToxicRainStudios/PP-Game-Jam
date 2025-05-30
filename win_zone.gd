extends Node2D

@onready var area = $Area2D
@export var target_node_path: NodePath
var target_node: Node2D

func _ready():
	target_node = get_node_or_null(target_node_path)

func _process(_delta):
	if target_node and is_inside_area(target_node.global_position):
		print("Detected inside area:", target_node.name)

func is_inside_area(world_pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	
	# Create the query parameters object
	var query = PhysicsPointQueryParameters2D.new()
	query.position = world_pos
	query.collide_with_bodies = false   # Only check Areas (change as needed)
	query.collide_with_areas = true
	query.collision_mask = area.collision_layer
	
	# Perform the intersection query
	var results = space_state.intersect_point(query)
	
	for result in results:
		if result.collider == area:
			return true
	return false
