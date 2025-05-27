extends RigidBody2D

func _ready():
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _integrate_forces(state):
	var contact_count = state.get_contact_count()
	for i in range(contact_count):
		var collider = state.get_contact_collider_object(i)
		
		var target = collider
		while target and not target.has_method("_start_possession"):
			target = target.get_parent()
		
		if target and target.name != "player":
			print("Starting possession on:", target.name)
			target._start_possession()
			
			var player = get_node("/root/World/player")
			var camera = player.get_node_or_null("Main Camera")
			if camera:
				player.remove_child(camera)
				target.add_child(camera)
				camera.position = Vector2.ZERO
				camera.set("current", true)  # Use set() if type mismatch
				print("Camera reparented to:", target.name)
			else:
				print("Camera not found")
			
			queue_free()
			break
