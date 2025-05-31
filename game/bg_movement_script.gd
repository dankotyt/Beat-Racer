extends Node2D

var scroll_speed: float = -500.0
var texture_height: float
var finish_spawned := false  # Чтобы не спавнилось дважды
var is_moving := true

func _ready():
	GameManager.stop_audio_and_bg()
	reset_movement()
	var first_bg = get_child(0) as Sprite2D
	texture_height = first_bg.texture.get_height()

func _process(delta: float):
	# Останавливаем движение если игра не в состоянии PLAYING
	if GameManager.state != GameManager.GameState.PLAYING:
		is_moving = false
		return
	
	is_moving = true  # Возобновляем движение при PLAYING
	
	# Движение фона
	if is_moving:
		for bg in get_children():
			if bg is Sprite2D and bg.region_enabled:
				bg.region_rect.position.y += scroll_speed * delta

		GameManager.distance_traveled += -scroll_speed * delta

		if not finish_spawned and GameManager.distance_traveled >= GameManager.track_length:
			spawn_finish_line()
			finish_spawned = true
			
func reset_movement():
	is_moving = true
	finish_spawned = false
	GameManager.distance_traveled = 0.0
	# Сбрасываем позицию фона (если нужно)
	for bg in get_children():
		if bg is Sprite2D and bg.region_enabled:
			bg.region_rect.position.y = 0

func spawn_finish_line():
	var finish_line_scene = preload("res://elements/finish_line/finish_line.tscn")
	var finish_line = finish_line_scene.instantiate()
	get_tree().current_scene.add_child(finish_line)
	finish_line.position = Vector2(0, -100)
