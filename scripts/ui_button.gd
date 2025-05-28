extends Node2D

@export var label_text: String = "Hello, world!"
@export var click_level: String = "World"

var is_hovered = false
var click_area = null

func _ready():
	# Setup the Label
	var label = get_node("Label")
	if label and label is Label:
		label.text = label_text
	else:
		print("Label node not found or wrong type.")

	# Setup the ClickArea ColorRect
	click_area = get_node("ButtonArea")
	if click_area and click_area is ColorRect:
		click_area.mouse_entered.connect(_on_mouse_entered)
		click_area.mouse_exited.connect(_on_mouse_exited)
		click_area.gui_input.connect(_on_gui_input)

func _on_mouse_entered():
	is_hovered = true
	click_area.material.set_shader_parameter("hovered", true)
	print("Hovering!")

func _on_mouse_exited():
	is_hovered = false
	click_area.material.set_shader_parameter("hovered", false)
	print("Not hovering.")

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_click()

func _on_click():
	get_tree().change_scene_to_file("res://scenes/" + click_level + ".tscn")
