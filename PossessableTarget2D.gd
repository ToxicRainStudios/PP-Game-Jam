extends BaseCharacter2D
class_name PossessableTarget2D


var is_possessed = false

func _start_possession():
	is_possessed = true
	
func _end_possession():
	is_possessed = false
