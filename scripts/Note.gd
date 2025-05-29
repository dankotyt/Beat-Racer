extends Area2D
class_name Note

# Паттерн "Состояние"
enum NoteState { ACTIVE, FADING, DESPAWNED }
var current_state = NoteState.ACTIVE

# Связь с пулом объектов (нот)
var speed := 500.0
var type: String
var note_pool: NotePool

func _process(delta):
	position.y += speed * delta
	var viewport_rect := get_viewport().get_visible_rect()
	
	# Автомат переключения состояний
	match current_state:
		NoteState.ACTIVE:
			if position.y > viewport_rect.end.y:
				current_state = NoteState.FADING
		NoteState.FADING:
			modulate.a = 1.0 - min(1.0, (position.y - viewport_rect.end.y) / 100.0)
			if position.y > viewport_rect.end.y + 100:
				current_state = NoteState.DESPAWNED
		NoteState.DESPAWNED:
			despawn()

func despawn():
	if note_pool:
		note_pool.despawn_note(self)
	else:
		queue_free()

func _exit_tree():
	if note_pool and note_pool.is_instance_valid(self):
		note_pool.despawn_note(self)
