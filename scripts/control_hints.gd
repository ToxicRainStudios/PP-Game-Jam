extends Node2D

@export var display_duration := 10.0  # Time in seconds to show controls
@onready var player = get_parent()

@export var control_hints := [
	{"text": "← Move Left (A)", "side": "left"},
	{"text": "→ Move Right (D)", "side": "right"},
	{"text": "↑ Jump (Space)", "side": "top"},
]

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
	# Keep labels following the player's position
	var pos = player.global_position
	if has_node("LabelLeft"):  $LabelLeft.global_position  = pos + Vector2(-100, 0)
	if has_node("LabelRight"): $LabelRight.global_position = pos + Vector2(100, 0)
	if has_node("LabelTop"):   $LabelTop.global_position   = pos + Vector2(0, -60)
	if has_node("LabelBottom"):$LabelBottom.global_position= pos + Vector2(0, 60)

func hide_all_labels():
	for side in ["Left", "Right", "Top", "Bottom"]:
		var label_name = "Label" + side
		if has_node(label_name):
			get_node(label_name).hide()
