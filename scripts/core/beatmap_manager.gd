class_name BeatmapManager
extends Node

# Класс BeatmapManager реализует паттерн Singleton 
static var instance: BeatmapManager

func _init():
	instance = self

func load_beatmap(file_name: String) -> Dictionary:
	var file = FileAccess.open("res://beatmaps/" + file_name, FileAccess.READ)
	return JSON.parse_string(file.get_as_text()) if file else {}
