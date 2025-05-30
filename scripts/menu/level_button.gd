@tool
extends TextureButton

@export var level_num := 1
@export var locked := true:
	set(value):
		locked = value
		disabled = locked
		if has_node("Label"):
			$Label.visible = not locked
			$Label.text = str(level_num) if not locked else ""

func _ready():
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	if not locked && has_node("Label"):
		$Label.text = str(level_num)

func _on_pressed():
	print("Button pressed! Level:", level_num)
	if not locked:
		# Прямая установка параметров без сигнала
		var difficulty = _get_difficulty(level_num)
		GameManager.difficulty = difficulty
		ProgressManager.selected_level = level_num
		print("Directly set difficulty:", difficulty, " level:", level_num)
		
		# Добавляем небольшую задержку перед сменой сцены
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file("res://scenes/menu/scn_choose_car.tscn")

func _get_difficulty(level: int) -> String:
	match level:
		1: return "easy"
		2: return "medium"
		3: return "hard"
		_: return "medium"
