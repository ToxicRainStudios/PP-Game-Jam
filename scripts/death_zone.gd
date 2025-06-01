extends Area2D

var is_live = true
@onready var timer: Timer = $Timer

func _on_body_entered(body):
	if is_live:
		Constants.possessed_something = false
		Engine.time_scale = 0.5
		Constants.play_sound_effect("sounds/colorscrimsontears__power-down.wav")
		timer.start()
		body.get_node("CollisionShape2D").queue_free()

func _on_timer_timeout():
	if is_live:
		Engine.time_scale = 1
		get_tree().reload_current_scene()
