class_name BeatmapManager
extends Node

# Паттерн "Одиночка" (объект-менеджер)
static var instance: BeatmapManager

# Инициализация BeatmapManager
func _init():
	if instance == null:
		instance = self
	else:
		queue_free()

# Загрузка битовой карты трека из файла
func load_beatmap(file_name: String) -> Dictionary:
	var file = FileAccess.open("res://beatmaps/" + file_name, FileAccess.READ)
	if file:
		return JSON.parse_string(file.get_as_text())
	return {}
