# STATIC VARS GO HERE OMFG
extends Node

var possessed_something = false

var camera_owner: Node = null  # Track who currently owns the camera

func reparent_camera(new_parent: Node):
	var player = get_node("/root/World/player")
	var camera = player.get_node_or_null("Main Camera")

	# If not found under player, check the last known owner
	if not camera and camera_owner and camera_owner.has_node("Main Camera"):
		camera = camera_owner.get_node("Main Camera")

	if camera:
		# Remove from old parent and add to new
		if camera.get_parent():
			camera.get_parent().remove_child(camera)
		new_parent.add_child(camera)
		camera.position = Vector2.ZERO
		camera.set("current", true)
		camera_owner = new_parent  # Update tracked owner
		print("Camera reparented to:", new_parent.name)
		possessed_something = true
	else:
		print("Camera not found")

func restore_camera_to_player():
	var player = get_node("/root/World/player")
	if not player:
		print("Player not found")
		return

	if camera_owner and camera_owner.has_node("Main Camera"):
		var camera = camera_owner.get_node("Main Camera")
		camera_owner.remove_child(camera)
		player.add_child(camera)
		camera.position = Vector2.ZERO
		camera.set("current", true)
		camera_owner = player
		print("Camera restored to player")
	else:
		print("Camera not found or not tracked")
		
func play_sound_effect(path: String):
	var player = AudioStreamPlayer.new()
	player.stream = load(path)
	get_tree().get_root().add_child(player)
	player.play()

	var duration = player.stream.get_length()
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(player, "queue_free"))
	player.add_child(timer)
	timer.start()
