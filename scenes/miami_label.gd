extends Label

@export var text_to_display: String = "YOU HAVE A NEW MESSAGE"
@export var char_delay: float = 0.03
@export var jitter_intensity: float = 0.6
@export var jitter_frequency: float = 0.05

var display_index := 0
var jitter_timer := 0.0
var base_position := Vector2.ZERO

func _ready():
	base_position = position
	text = ""
	display_index = 0
	jitter_timer = 0.0
	start_typing()

func start_typing():
	display_index = 0
	text = ""
	_reveal_next_char()

func _reveal_next_char():
	if display_index < text_to_display.length():
		text += text_to_display[display_index]
		display_index += 1
		await get_tree().create_timer(char_delay).timeout
		_reveal_next_char()

func _process(delta):
	# Always jitter the label position
	jitter_timer += delta
	if jitter_timer >= jitter_frequency:
		jitter_timer = 0
		position = base_position + Vector2(
			randf_range(-jitter_intensity, jitter_intensity),
			randf_range(-jitter_intensity, jitter_intensity)
		)
