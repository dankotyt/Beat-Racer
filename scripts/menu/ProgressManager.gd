extends Node

var unlocked_levels := [1]  # По умолчанию открыт только 1 уровень
var level_scores := {1: 0, 2: 0, 3: 0}  # Счет для каждого уровня
var current_level: int = 1
var player_score: int = 0
var selected_level: int = 1 
var available_cars := ["OrangeCar", "GreenCar", "LightGreenCar"]
var selected_car: String = "OrangeCar"  # Машина по умолчанию
var car_textures_path := "res://sprites/"  # Базовый путь к текстурам
var current_car_texture: String = car_textures_path + "carOrange.png"  # Полный путь к текстуре

func unlock_level(level: int):
	if not level in unlocked_levels:
		unlocked_levels.append(level)
		save_progress()

func save_progress():
	var save_data = {
		"unlocked_levels": unlocked_levels,
		"level_scores": level_scores,
		"selected_car": selected_car,
		"current_car_texture": current_car_texture,
		"selected_level": selected_level  # Сохраняем выбранный уровень
	}
	FileAccess.open("user://progress.save", FileAccess.WRITE).store_var(save_data)

func load_progress():
	if FileAccess.file_exists("user://progress.save"):
		var data = FileAccess.open("user://progress.save", FileAccess.READ).get_var()
		unlocked_levels = data["unlocked_levels"]
		level_scores = data["level_scores"]
		selected_car = data.get("selected_car", "OrangeCar")
		current_car_texture = data.get("current_car_texture", car_textures_path + "carOrange.png")
		selected_level = data.get("selected_level", 1)  # Загружаем выбранный уровень

# Устанавливаем текстуру выбранной машины
func set_car_texture(car_name: String):
	selected_car = car_name
	current_car_texture = car_textures_path + "car" + car_name + ".png"
	save_progress()
