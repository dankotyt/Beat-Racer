extends Node2D

@onready var clip_control = $BGButtons/ClipControl

func _ready():
	print("Level selection initialized")
	if not clip_control:
		push_error("ClipControl not found!")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/scn_game_menu.tscn")
