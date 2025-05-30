extends Node

signal game_over
signal win

enum GameState { PLAYING, GAME_OVER, WIN }

var state: GameState = GameState.PLAYING
var track_length: float = 65000.0  # длина трассы в пикселях
var distance_traveled: float = 0.0
var difficulty = "hard"  # "easy", "medium", "hard"

func show_lose_screen():
		get_tree().change_scene_to_file("res://elements/screens/lose.tscn")

func show_win_screen():
		get_tree().change_scene_to_file("res://elements/screens/win_screen.tscn")
		
func stop_audio_and_bg():
	AudioManager.set_music_state(false)
	
	var bg = get_tree().get_root().find_child("bg", true, false)
	if bg:
		bg.queue_free()
