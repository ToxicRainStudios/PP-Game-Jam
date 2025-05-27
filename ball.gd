extends RigidBody2D

func _ready():
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _integrate_forces(state):
	var contact_count = state.get_contact_count()
	for i in range(contact_count):
		var collider = state.get_contact_collider_object(i)
		print("Collided with:", collider.name)
		if collider and collider.name != "player" and collider.has_method("_start_possession"):
			collider._start_possession()
			queue_free()
			break
