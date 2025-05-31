extends Node

signal game_over
signal win

enum GameState { PLAYING, GAME_OVER, WIN }

var state: GameState = GameState.PLAYING
var track_length: float = 57500.0  # длина трассы в пикселях
var distance_traveled: float = 0.0
var difficulty = "medium"  # "easy", "medium", "hard"

func _ready():
	reset_game()
	print("GameManager ready, current difficulty:", difficulty)

func show_lose_screen():
	state = GameState.GAME_OVER
	get_tree().change_scene_to_file("res://elements/screens/lose.tscn")

func show_win_screen():
	state = GameState.WIN
	get_tree().change_scene_to_file("res://elements/screens/win_screen.tscn")

func reset_game():
	# Сбрасываем все параметры игры
	state = GameState.PLAYING
	distance_traveled = 0.0

func stop_audio_and_bg():
	AudioManager.set_music_state(false)
	
	var bg = get_tree().get_root().find_child("bg", true, false)
	if bg:
		bg.queue_free()
