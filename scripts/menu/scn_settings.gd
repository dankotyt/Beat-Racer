extends Node2D

func _ready():
	$HSlider.value = AudioManager.current_volume

func _on_h_slider_value_changed(value):
	AudioManager.set_volume(value)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/scn_game_menu.tscn") 
