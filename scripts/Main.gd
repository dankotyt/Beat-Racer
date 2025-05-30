extends Node2D

# Подключение проигрывателя аудиофайлов
@onready var audio_player = $AudioStreamPlayer

# Паттерн "Состояние" - определение состояния проигрывателя
var beatmap: Dictionary
var current_track := ""
var sec_per_beat: float
var note_state = {
	"strong": {"idx": 0},
	"medium": {"idx": 0},
	"weak": {"idx": 0},
	"hybrid": {"idx": 0}
}

# Паттерн "Пул объектов"
var note_pool: NotePool

# Элементы паттерна "Наблюдатель"
var flash_rect: ColorRect
var flash_timer: Timer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Инициализация пула объектов (нот/препятствий)
	note_pool = NotePool.new()
	add_child(note_pool)
	
	# Настройка Наблюдателя (вспышки при ударе в музыке)
	init_flash_observer()
	
	# Паттерн "Стратегия" - использование одной из стратегий загрузки треков
	load_random_track()

func init_flash_observer():
	flash_rect = ColorRect.new()
	flash_rect.color = Color(1, 1, 1, 0)
	flash_rect.z_index = 1000
	flash_rect.size = get_viewport_rect().size
	flash_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(flash_rect)
	
	flash_timer = Timer.new()
	flash_timer.one_shot = true
	flash_timer.timeout.connect(_on_flash_timeout)
	add_child(flash_timer)

func _on_flash_timeout():
	var tween = create_tween()
	tween.tween_property(flash_rect, "color:a", 0.0, 0.3)

# Паттерн "Команда" - очередь сигналов Наблюдателю на включение вспышки
func trigger_flash(intensity: float = 0.5):
	flash_rect.color = Color(1, 1, 1, intensity)
	flash_timer.start(0.1)

# Паттерн "Стратегия" - применение стратегии выбора трека
func load_random_track():
	var tracks = ["akiaura", "furious", "mostwanted", "northside", "pusher"]
	var selector = TrackSelector.create_strategy("random")
	current_track = selector.select_track(tracks)
	beatmap = BeatmapManager.instance.load_beatmap("beatmap_" + current_track + ".json")
	
	if beatmap and beatmap.has("bpm"):
		sec_per_beat = 60.0 / beatmap["bpm"]
		# Сброс состояния проигрывателя
		for key in note_state:
			note_state[key].idx = 0
	
	audio_player.stream = load("res://audio/" + current_track + ".mp3")
	audio_player.play()

func _process(_delta):
	if !audio_player.playing: return
	
	var current_time = get_accurate_playback_time()
	if not beatmap: return
	
	# Паттерн "Состояние" - обработка различных состояний ноты (препятствия)
	process_note_type("strong", current_time, 1)
	process_note_type("medium", current_time, 2)
	process_note_type("weak", current_time, 3)
	process_hybrid_notes(current_time)

func process_note_type(type: String, current_time: float, lane: int):
	if note_state[type].idx < beatmap[type + "_beats"].size():
		var beat_time = beatmap[type + "_beats"][note_state[type].idx]
		if current_time >= beat_time - 0.05:
			spawn_note(beat_time, type, lane)
			note_state[type].idx += 1

func process_hybrid_notes(current_time: float):
	var type = "hybrid"
	if note_state[type].idx < beatmap["hybrid_beats"].size():
		var hybrid_beat = beatmap["hybrid_beats"][note_state[type].idx]
		if current_time >= hybrid_beat["time"] - 0.05:
			spawn_note(hybrid_beat["time"], "hybrid_" + hybrid_beat["categories"][0], 4)
			note_state[type].idx += 1

func get_accurate_playback_time() -> float:
	return audio_player.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

# Паттерн "Фабричный метод" - создаёт ноты с разными параметрами
func spawn_note(time: float, type: String, lane: int):
	var note = note_pool.spawn_note()
	note.position = Vector2(lane * 200 + 100 + randi_range(0, 50), -50)
	note.type = type
	note.note_pool = note_pool
	
	# Паттерн "Стратегия" выбирает разные виды нот в зависимости от типа удара в треке
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
