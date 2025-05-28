extends Area2D

var speed := 500.0
var type: String
var note_pool: NotePool  # Будет установлен извне

func _process(delta):
	position.y += speed * delta
	var viewport_rect := get_viewport().get_visible_rect()
	
	# Начинаем исчезать при приближении к границе
	if position.y > viewport_rect.end.y:
		modulate.a = 1.0 - min(1.0, (position.y - viewport_rect.end.y) / 100.0)
	
	# Полное удаление после выхода за буферную зону
	if position.y > viewport_rect.end.y + 100:
		if note_pool:
			note_pool.despawn_note(self)
		else:
			queue_free()

func _exit_tree():
	# Очистка при принудительном удалении
	if note_pool and note_pool.is_instance_valid(self):
		note_pool.despawn_note(self)
