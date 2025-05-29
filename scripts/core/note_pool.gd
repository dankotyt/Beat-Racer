class_name NotePool
extends Node

const NOTE_SCENE = preload("res://scenes/Note.tscn")
var pool: Array = []

# Интерфейс пула объектов (нот)
func spawn_note() -> Note:
	if pool.is_empty():
		return create_new_note()
	var note = pool.pop_back()
	note.show()
	return note

func despawn_note(note: Note):
	note.hide()
	note.current_state = Note.NoteState.ACTIVE
	note.modulate.a = 1.0
	pool.append(note)

# Фабричный метод создания нот
func create_new_note() -> Note:
	var note = NOTE_SCENE.instantiate()
	note.show()
	return note
