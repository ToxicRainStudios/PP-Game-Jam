extends Control

@onready var ost_player = $AudioStreamPlayer2D

func _ready():
	ost_player.play()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levelselect.tscn") 
	
func _on_quit_button_pressed():
	get_tree().quit()
