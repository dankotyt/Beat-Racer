extends Node2D

@onready var audio_player = $AudioStreamPlayer

var beatmap: Dictionary
var note_pool: NotePool
var current_track := ""
var next_strong_idx := 0
var next_weak_idx := 0
var next_medium_idx := 0
var next_hybrid_idx := 0
var sec_per_beat: float

var flash_rect: ColorRect
var flash_timer: Timer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	note_pool = NotePool.new()
	add_child(note_pool)
	
	# Создаем эффект вспышки
	flash_rect = ColorRect.new()
	flash_rect.color = Color(1, 1, 1, 0)
	flash_rect.z_index = 1000
	flash_rect.size = get_viewport_rect().size
	flash_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(flash_rect)
	
	# Таймер для скрытия вспышки
	flash_timer = Timer.new()
	flash_timer.one_shot = true
	flash_timer.timeout.connect(_on_flash_timeout)
	add_child(flash_timer)
	
	load_random_track()
	
func _on_flash_timeout():
	# Плавное исчезновение вспышки
	var tween = create_tween()
	tween.tween_property(flash_rect, "color:a", 0.0, 0.3)

func trigger_flash(intensity: float = 0.5):
	# Активируем вспышку
	flash_rect.color = Color(1, 1, 1, intensity)
	flash_timer.start(0.1)  # Начнем исчезать через 0.1 сек (для короткой вспышки)

func load_random_track():
	var tracks = ["akiaura", "furious", "mostwanted", "northside", "pusher"]
	var selector = TrackSelector.create_strategy("random")
	current_track = selector.select_track(tracks)
	beatmap = BeatmapManager.instance.load_beatmap("beatmap_" + current_track + ".json")
	if beatmap and beatmap.has("bpm"):
		sec_per_beat = 60.0 / beatmap["bpm"]
		# Сброс индексов при загрузке нового трека
		next_strong_idx = 0
		next_weak_idx = 0
		next_medium_idx = 0
		next_hybrid_idx = 0
	audio_player.stream = load("res://audio/" + current_track + ".mp3")
	audio_player.play()

func _process(_delta):
	if !audio_player.playing:
		return
	
	var current_time = get_accurate_playback_time()
	
	# Проверка существования beatmap и обязательных полей
	if not beatmap or not beatmap.has("strong_beats") or not beatmap.has("weak_beats") or not beatmap.has("medium_beats"):
		return
	
	# Спавн сильных ударов
	if next_strong_idx < beatmap["strong_beats"].size():
		var beat_time = beatmap["strong_beats"][next_strong_idx]
		if current_time >= beat_time - 0.05:
			spawn_note(beat_time, "strong", 1)
			next_strong_idx += 1
	
	# Спавн средних ударов
	if next_medium_idx < beatmap["medium_beats"].size():
		var beat_time = beatmap["medium_beats"][next_medium_idx]
		if current_time >= beat_time - 0.05:
			spawn_note(beat_time, "medium", 2)
			next_medium_idx += 1
	
	# Спавн слабых ударов
	if next_weak_idx < beatmap["weak_beats"].size():
		var beat_time = beatmap["weak_beats"][next_weak_idx]
		if current_time >= beat_time - 0.05:
			spawn_note(beat_time, "weak", 3)
			next_weak_idx += 1
	
	# Спавн гибридных ударов
	if next_hybrid_idx < beatmap["hybrid_beats"].size():
		var hybrid_beat = beatmap["hybrid_beats"][next_hybrid_idx]
		if current_time >= hybrid_beat["time"] - 0.05:
			# Для гибридов используем специальный тип
			var lane = 4  # Отдельная дорожка для гибридов
			spawn_note(hybrid_beat["time"], "hybrid_" + hybrid_beat["categories"][0], lane)
			next_hybrid_idx += 1

func get_accurate_playback_time() -> float:
	return audio_player.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

func spawn_note(time: float, type: String, lane: int):
	var note = note_pool.spawn_note()
		
	note.position = Vector2(lane * 200 + 100 + randi_range(0, 50), -50)
	note.type = type
	note.note_pool = note_pool
	
	# Настройка визуала для всех типов
	match type:
		"strong":
			note.scale = Vector2(1.3, 1.3)
			note.modulate = Color.RED
			trigger_flash(0.8)
		"medium":
			note.scale = Vector2(1.0, 1.0)
			note.modulate = Color.YELLOW
			trigger_flash(0.4)
		"weak":
			note.scale = Vector2(0.7, 0.7)
			note.modulate = Color.BLUE
		"hybrid_strong":
			if randi() % 2 == 0:
				note.scale = Vector2(1.3, 1.3)
				note.modulate = Color.PURPLE
			else:
				note.scale = Vector2(1.0, 1.0)
				note.modulate = Color.PURPLE
			trigger_flash(0.6)
		"hybrid_medium":
			if randi() % 2 == 0:
				note.scale = Vector2(0.7, 0.7)
				note.modulate = Color.PURPLE
			else:
				note.scale = Vector2(1.0, 1.0)
				note.modulate = Color.PURPLE
			note.modulate = Color.ORANGE
	
	call_deferred("add_child", note)
