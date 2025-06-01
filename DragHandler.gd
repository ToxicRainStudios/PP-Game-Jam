extends Node

class_name DragHandler

var grabbed_body: Node2D = null
var grabbed_body_original_rotation := 0.0
var grab_joint: PinJoint2D = null
var proxy: RigidBody2D = null

func grab(caller: Node2D, raycast: RayCast2D, scene_root: Node):
	if raycast.is_colliding():
		var body = raycast.get_collider()
		if body is CharacterBody2D:
			grabbed_body = body
			grabbed_body_original_rotation = body.global_rotation
			_create_proxy_for_character(body, caller)

			body.set_physics_process(false)

			grab_joint = PinJoint2D.new()
			grab_joint.position = raycast.get_collision_point()
			grab_joint.node_a = caller.get_path()
			grab_joint.node_b = proxy.get_path()
			scene_root.add_child(grab_joint)
		elif body is RigidBody2D:
			grabbed_body = body
			grab_joint = PinJoint2D.new()
			grab_joint.position = raycast.get_collision_point()
			grab_joint.node_a = caller.get_path()
			grab_joint.node_b = body.get_path()
			scene_root.add_child(grab_joint)

func release():
	if grab_joint and grab_joint.get_parent():
		grab_joint.queue_free()
		grab_joint = null

	if grabbed_body:
		if grabbed_body is CharacterBody2D:
			grabbed_body.show()
			grabbed_body.set_physics_process(true)
			grabbed_body.global_rotation = grabbed_body_original_rotation
		grabbed_body = null

	if proxy and proxy.is_inside_tree():
		proxy.queue_free()
	proxy = null

func update_grabbed_transform():
	if grabbed_body and grabbed_body is CharacterBody2D and proxy:
		grabbed_body.global_position = proxy.global_position
		grabbed_body.global_rotation = proxy.global_rotation

func _create_proxy_for_character(character: CharacterBody2D, caller: Node2D):
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

	caller.get_parent().add_child(proxy)
