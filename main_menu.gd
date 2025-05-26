extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")  # Updated for Godot 4.x

func _on_quit_button_pressed():
	get_tree().quit()
