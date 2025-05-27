extends Area2D

@onready var timer: Timer = $Timer


func _on_body_entered(body):
	Engine.time_scale = 2
	timer.start()
	body.x += 100
	body.get_node("CollisionShape2D").queue_free()
	


func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
