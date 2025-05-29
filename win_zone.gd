extends Node2D

@onready var collision_shape = $Area2D

func _ready():
	collision_shape.body_entered.connect(Callable(self, "_on_body_entered"))
	collision_shape.body_exited.connect(Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	print(body.namea)
	if body.name == "player":  # or check using groups: if body.is_in_group("player"):
		print("Player entered area")

func _on_body_exited(body: Node) -> void:
	if body.name == "player":
		print("Player exited area")
