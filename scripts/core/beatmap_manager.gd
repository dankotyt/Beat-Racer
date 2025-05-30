class_name BeatmapManager
extends Node

var note_scene: PackedScene
var note_parent: Node
var audio_player: AudioStreamPlayer2D
var flash_rect: ColorRect
var flash_timer: Timer

var ObstaclePool = preload("res://scripts/core/obstacle_pool.gd")
var obstacle_pool: ObstaclePool

# Синглтон
static var instance: BeatmapManager

var beatmap: Dictionary
var sec_per_beat: float
var note_state = {
	"strong": {"idx": 0},
	"medium": {"idx": 0},
	"weak": {"idx": 0},
	"hybrid": {"idx": 0}
}

var x_min := 380
var x_max := 1170

const OBSTACLES = {
	"easy": [
		preload("res://elements/obstacles/spikes_obstacle/spikes_obstacle.tscn"),
		preload("res://elements/obstacles/Rock_obstacle/rock_obstacle.tscn"),
		preload("res://elements/obstacles/tree_obstacle/tree_obstacle_left.tscn"),
		preload("res://elements/obstacles/tree_obstacle/tree_obstacle_right.tscn"),
		preload("res://elements/obstacles/Police_car_obstacle/police_car.tscn")
	],
	"medium": [
		preload("res://elements/obstacles/spikes_obstacle/spikes_obstacle.tscn"),
		preload("res://elements/obstacles/Rock_obstacle/rock_obstacle.tscn"),
		preload("res://elements/obstacles/tree_obstacle/tree_obstacle_left.tscn"),
		preload("res://elements/obstacles/tree_obstacle/tree_obstacle_right.tscn"),
		preload("res://elements/obstacles/Police_car_obstacle/police_car.tscn"),
		preload("res://elements/obstacles/car_obstacle/car_obstacle_UAZ.tscn"),
		preload("res://elements/obstacles/car_obstacle/car_obstacle_VAN.tscn"),
		preload("res://elements/obstacles/car_obstacle/bus_obstacle.tscn")
	],
	"hard": [
		preload("res://elements/obstacles/spikes_obstacle/spikes_obstacle.tscn"),
		preload("res://elements/obstacles/Rock_obstacle/rock_obstacle.tscn"),
		preload("res://elements/obstacles/tree_obstacle/tree_obstacle_left.tscn"),
		preload("res://elements/obstacles/tree_obstacle/tree_obstacle_right.tscn"),
		preload("res://elements/obstacles/car_obstacle/car_obstacle.tscn"),
		preload("res://elements/obstacles/Police_car_obstacle/police_car.tscn"),
		preload("res://elements/obstacles/car_obstacle/car_obstacle_UAZ.tscn"),
		preload("res://elements/obstacles/car_obstacle/car_obstacle_VAN.tscn"),
		preload("res://elements/obstacles/car_obstacle/bus_obstacle.tscn")
	]
}

func _init():
	if instance == null:
		instance = self
	else:
		queue_free()

func load_beatmap(file_name: String) -> Dictionary:
	var path = "res://beatmaps(sp)/" + file_name
	print(path)
	if not FileAccess.file_exists(path):
		push_error("Beatmap file not found: " + path)
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	
	if not json_data is Dictionary:
		push_error("Invalid beatmap format")
		return {}
	
	return json_data

func get_accurate_playback_time() -> float:
	return audio_player.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

func process_beatmap(raw_beatmap: Dictionary):
	var current_time = get_accurate_playback_time()
	if "strong_beats" in raw_beatmap:
		var beat_time = raw_beatmap["strong_beats"][note_state["strong"].idx]
		if abs(current_time - beat_time) <= 0.18:
			var pool = OBSTACLES[GameManager.difficulty]
			var obstacle_scene = pool[randi() % pool.size()]
			var obstacle = obstacle_scene.instantiate()
			obstacle.position = Vector2(randi_range(x_min, x_max), -200)
			get_tree().current_scene.add_child(obstacle)
			note_state["strong"].idx += 1 
	if "medium_beats" in raw_beatmap:
		var beat_time = raw_beatmap["medium_beats"][note_state["medium"].idx]
		if abs(current_time - beat_time) <= 0.17:
			var pool = OBSTACLES[GameManager.difficulty]
			var obstacle_scene = pool[randi() % pool.size()]
			var obstacle = obstacle_scene.instantiate()
			obstacle.position = Vector2(randi_range(x_min, x_max), -200)
			get_tree().current_scene.add_child(obstacle)
			note_state["medium"].idx += 1 
	if "weak_beats" in raw_beatmap:
		var beat_time = raw_beatmap["weak_beats"][note_state["weak"].idx]
		if abs(current_time - beat_time) <= 0.16:
			var pool = OBSTACLES[GameManager.difficulty]
			var obstacle_scene = pool[randi() % pool.size()]
			var obstacle = obstacle_scene.instantiate()
			obstacle.position = Vector2(randi_range(x_min, x_max), -200)
			get_tree().current_scene.add_child(obstacle)
			note_state["weak"].idx += 1 

func start(beatmap_file: String):
	obstacle_pool = ObstaclePool.new()
	add_child(obstacle_pool)

	init_flash_observer()

	beatmap = load_beatmap(beatmap_file)  # Используем переданное имя файла
	if beatmap.is_empty():
		return

	var processed_obstacles = process_beatmap(beatmap)

	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(process_beatmap.bind(beatmap))
	timer.start(0.001)

	if beatmap.has("bpm"):
		sec_per_beat = 60.0 / beatmap["bpm"]
		for key in note_state:
			note_state[key].idx = 0

	set_process(true)

func init_flash_observer():
	flash_rect = ColorRect.new()
	flash_rect.color = Color(1, 1, 1, 0)
	flash_rect.z_index = 1000
	flash_rect.size = get_viewport().get_visible_rect().size
	flash_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	note_parent.add_child(flash_rect)

	flash_timer = Timer.new()
	flash_timer.one_shot = true
	flash_timer.timeout.connect(_on_flash_timeout)
	note_parent.add_child(flash_timer)

func trigger_flash(intensity: float = 0.5):
	if flash_rect and flash_timer:
		flash_rect.color = Color(1, 1, 1, intensity)
		flash_timer.start(0.1)

func _on_flash_timeout():
	var tween = create_tween()
	tween.tween_property(flash_rect, "color:a", 0.0, 0.3)

func _process(_delta):
	if not audio_player or not audio_player.playing:
		return

	# Учитываем задержку звука и текущую позицию трека
	var audio_latency = AudioServer.get_output_latency()
	var current_time = audio_player.get_playback_position() + audio_latency
	
	process_note_type("strong", current_time)
	process_note_type("medium", current_time)
	process_note_type("weak", current_time)
	process_hybrid_notes(current_time)


func process_note_type(type: String, current_time: float):
	if not beatmap.has(type + "_beats"):
		return
	
	var beats = beatmap[type + "_beats"]
	var idx = note_state[type].idx

	if idx < beats.size():
		var beat_time = beats[idx]
		if current_time >= beat_time - 0.15:
			match type:
				"strong": trigger_flash(0.2)
				"medium": trigger_flash(0.5)
				"weak": trigger_flash(0.3)
			note_state[type].idx += 1

func process_hybrid_notes(current_time: float):
	var type = "hybrid"
	if not beatmap.has("hybrid_beats"):
		return
	
	var beats = beatmap["hybrid_beats"]
	var idx = note_state[type].idx

	if idx < beats.size():
		var beat = beats[idx]
		if beat is Dictionary and beat.has("time") and current_time >= beat["time"] - 0.05:
			trigger_flash(0.6)
			note_state[type].idx += 1
