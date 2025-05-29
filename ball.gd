extends RigidBody2D

func _ready():
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _integrate_forces(state):
	var contact_count = state.get_contact_count()
	for i in range(contact_count):
		var collider = state.get_contact_collider_object(i)

		var target = collider
		while target and not (target is PossessableTarget2D):
			target = target.get_parent()

		if target and target.name != "player":
			print("Starting possession on:", target.name)
			target._start_possession()

			Constants.possessed_target = target
			Constants.reparent_camera(target)
			queue_free()
			break
