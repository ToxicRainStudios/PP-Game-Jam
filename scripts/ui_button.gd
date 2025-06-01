extends Node2D

@export var label_text: String = "Hello, world!"
@export var click_level: String = "World"

func _ready():
	var click_area = $ButtonArea
	var label = $Label
	
	if label and label is Label:
		label.text = label_text
	
	if click_area and click_area is ColorRect:
		if click_area.material:
			click_area.material = click_area.material.duplicate()
		
		# Connect signals with Godot 4 syntax (using `@` or explicit function reference)
		click_area.mouse_entered.connect(_on_mouse_entered)
		click_area.mouse_exited.connect(_on_mouse_exited)
		click_area.gui_input.connect(_on_gui_input)
	else:
		print("click_area missing or wrong type")

func _on_mouse_entered():
	if $ButtonArea and $ButtonArea.material:
		$ButtonArea.material.set_shader_parameter("hovered", true)
	print("Hovering!")

func _on_mouse_exited():
	if $ButtonArea and $ButtonArea.material:
		$ButtonArea.material.set_shader_parameter("hovered", false)
	print("Not hovering.")

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_click()

func _on_click():
	get_tree().change_scene_to_file("res://scenes/" + click_level + ".tscn")
