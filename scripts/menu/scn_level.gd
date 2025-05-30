extends Node2D

@onready var clip_control = $BGButtons/ClipControl

func _ready():
	if clip_control:
		clip_control.initialized.connect(_on_clip_ready)
	else:
		push_error("ClipControl NOT FOUND in BGButtons!")
		
func _on_clip_ready():
	print("ClipControl INITIALIZED")
	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/scn_game_menu.tscn")
