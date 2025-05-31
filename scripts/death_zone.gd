extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body):
	Engine.time_scale = 0.5
	Constants.play_sound_effect("sounds/colorscrimsontears__power-down.wav")
	timer.start()
	body.get_node("CollisionShape2D").queue_free()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
