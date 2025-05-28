class_name NotePool
extends Node

const NOTE_SCENE = preload("res://scenes/Note.tscn")
var pool: Array = []

func spawn_note() -> Node2D:
	var note = pool.pop_back() if not pool.is_empty() else NOTE_SCENE.instantiate()
	note.show()
	return note

func despawn_note(note: Node2D):
	note.hide()
	pool.append(note)
