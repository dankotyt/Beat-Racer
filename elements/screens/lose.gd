extends Node

func _input(event):
		if event is InputEventMouseButton and event.pressed:
				get_tree().quit()
