extends Node2D

@export var display_duration := 10.0  # Time in seconds to show controls
@onready var player = get_parent()

@export var control_hints := [
	{"text": "← A", "side": "left"},
	{"text": "→ D", "side": "right"},
	{"text": "↑ Space", "side": "top"},
]

@export var offset_left := Vector2(-100, 0)
@export var offset_right := Vector2(100, 0)
@export var offset_top := Vector2(0, -60)
@export var offset_bottom := Vector2(0, 60)

func _ready():
	for hint in control_hints:
		var label_name = "Label" + hint.side.capitalize()
		if has_node(label_name):
			var label = get_node(label_name)
			label.text = hint.text
			label.visible = true

	await get_tree().create_timer(display_duration).timeout
	hide_all_labels()

func _process(_delta):
	var center = player.global_position  # This assumes the origin is the center

	if has_node("LabelLeft"):   $LabelLeft.global_position   = center + offset_left
	if has_node("LabelRight"):  $LabelRight.global_position  = center + offset_right
	if has_node("LabelTop"):    $LabelTop.global_position    = center + offset_top
	if has_node("LabelBottom"): $LabelBottom.global_position = center + offset_bottom

func hide_all_labels():
	for side in ["Left", "Right", "Top", "Bottom"]:
		var label_name = "Label" + side
		if has_node(label_name):
			get_node(label_name).hide()
