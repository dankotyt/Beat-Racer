class_name BeatmapManager
extends Node

# Настройки
var note_scene: PackedScene
var note_parent: Node
var audio_player: AudioStreamPlayer2D

# Добавляем предварительное объявление класса
var ObstaclePool = preload("res://scripts(sp)/core/obstacle_pool.gd")
var obstacle_pool: ObstaclePool

# Одиночка (Singleton)
static var instance: BeatmapManager

func _init():
	if instance == null:
		instance = self
	else:
		queue_free()

# Загрузка битмапы из JSON
func load_beatmap(file_name: String) -> Dictionary:
	var path = "res://beatmaps(sp)/" + file_name
	if not FileAccess.file_exists(path):
		push_error("Beatmap file not found: " + path)
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	
	if not json_data is Dictionary:
		push_error("Invalid beatmap format")
		return {}
	
	return json_data

func process_beatmap(raw_beatmap: Dictionary) -> Array:
	var obstacles = []
	
	if "car_beats" in raw_beatmap:
		for time in raw_beatmap["car_beats"]:
			obstacles.append({"time": time, "type": "car"})
	
	if "spikes_beats" in raw_beatmap:
		for time in raw_beatmap["spikes_beats"]:
			obstacles.append({"time": time, "type": "spikes"})
	
	if "tree_left_beats" in raw_beatmap:
		for time in raw_beatmap["tree_left_beats"]:
			obstacles.append({"time": time, "type": "tree_left"})
	
	if "tree_right_beats" in raw_beatmap:
		for time in raw_beatmap["tree_right_beats"]:
			obstacles.append({"time": time, "type": "tree_right"})
	
	obstacles.sort_custom(func(a, b): return a["time"] < b["time"])
	return obstacles

# Основной метод запуска
func start():
	# Инициализируем пул препятствий
	obstacle_pool = ObstaclePool.new()
	add_child(obstacle_pool)
	
	var raw_beatmap = load_beatmap("beatmap_akiaura.json")
	if raw_beatmap.is_empty():
		return
	
	var processed_obstacles = process_beatmap(raw_beatmap)
	print("Loaded ", processed_obstacles.size(), " obstacles")
	
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_spawn_obstacles.bind(processed_obstacles))
	timer.start(0.1)

func _spawn_obstacles(obstacles: Array):
	if not audio_player.playing:
		return
	
	var current_time = audio_player.get_playback_position()
	
	while not obstacles.is_empty() and obstacles[0]["time"] <= current_time + 1.0:
		var obstacle_data = obstacles.pop_front()
		var obstacle = obstacle_pool.spawn_obstacle(obstacle_data["type"])
		
		if obstacle:
			note_parent.add_child(obstacle)
			match obstacle_data["type"]:
				"car":
					obstacle.position = Vector2(randf_range(300, 1000), -100)
				"spikes":
					obstacle.position = Vector2(600, -100)
				"tree_left":
					obstacle.position = Vector2(270, -100)
				"tree_right":
					obstacle.position = Vector2(1300, -100)
