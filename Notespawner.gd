extends Node2D

@onready var audio_player = $AudioStreamPlayer
var beatmap_manager

func _ready():
	var random_track = get_random_track("res://audio(sp)/")
	if random_track == "":
		push_error("No audio files found")
		return

	var audio_stream = load(random_track)
	if audio_stream == null:
		push_error("Failed to load audio file: " + random_track)
		return

	audio_player.stream = audio_stream
	audio_player.play()

	# Загрузка менеджера битмап
	var beatmap_script = load("res://scripts/core/beatmap_manager.gd")
	if beatmap_script == null:
		push_error("Failed to load beatmap_manager.gd")
		return

	beatmap_manager = beatmap_script.new()
	if beatmap_manager == null:
		push_error("Failed to create beatmap_manager instance")
		return

	var note_scene = preload("res://scenes/Note.tscn")
	if note_scene == null:
		push_error("Failed to load Note scene")
		return

	beatmap_manager.note_scene = note_scene
	beatmap_manager.note_parent = self
	beatmap_manager.audio_player = audio_player

	beatmap_manager.start()

# Получение случайного трека из папки
func get_random_track(path: String) -> String:
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Failed to open directory: " + path)
		return ""

	dir.list_dir_begin()
	var files = []
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".mp3"):
			files.append(path + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	if files.is_empty():
		return ""

	return files[randi() % files.size()]
