extends Node

func _ready() -> void:
	GameManager.state = GameManager.GameState.PLAYING

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/scn_game_menu.tscn")


func _on_rerun_button_pressed() -> void:
	var game_scene = load("res://game/game.tscn").instantiate()
	
	# Очищаем текущую сцену
	get_tree().current_scene.queue_free()
	
	# Добавляем новую сцену
	get_tree().root.add_child(game_scene)
	get_tree().current_scene = game_scene
