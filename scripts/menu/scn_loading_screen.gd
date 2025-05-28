extends Node2D

func _ready():
	# Ждём 2 секунды, затем переключаем сцену
	await get_tree().create_timer(4.0).timeout
	change_to_main_menu()

func change_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/menu/scn_game_menu.tscn")
