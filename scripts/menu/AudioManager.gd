extends Node

static var instance: AudioManager

var music_player: AudioStreamPlayer
var is_music_playing := false
var current_volume: float = 0.1

func _init():
	instance = self
	setup_music()

# Загружаем музыку, но не воспроизводим сразу
func setup_music():
	if music_player == null:
		music_player = AudioStreamPlayer.new()
		var stream = load("res://audio/cyberpunk-street.ogg")
		stream.loop = true
		music_player.stream = stream
		add_child(music_player)

# Включаем/выключаем музыку
func set_music_state(enable: bool):
	if music_player == null:
		setup_music()
	
	is_music_playing = enable
	
	if enable:
		music_player.play()
	else:
		music_player.stop() 

# Управление громкостью (0..1)
func set_volume(value: float):
	if music_player == null:
		setup_music()
	
	current_volume = value  # Сохраняем текущее значение
	
	if value == 0:
		music_player.volume_db = -80.0
	else:
		if !is_music_playing:
			music_player.play()
		music_player.volume_db = linear_to_db(value)

func toggle_sound():
	if current_volume > 0:
		set_volume(0)
	else:
		set_volume(1)
