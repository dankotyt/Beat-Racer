extends Node

func _ready() -> void:
	GameManager.state = GameManager.GameState.PLAYING

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/scn_game_menu.tscn")
