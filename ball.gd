extends RigidBody2D

func _ready():
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _integrate_forces(state):
	if get_colliding_bodies().size() > 0:
		queue_free()
