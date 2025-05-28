extends Node2D

# Массив машин в порядке переключения
var cars: Array[Node] = []
var current_car_index := 0

func _ready():
	# Находим все ноды машин и сохраняем ссылки
	cars = [
		$BGButtons/ClipControl/OrangeCar,
		$BGButtons/ClipControl/GreenCar,
		$BGButtons/ClipControl/LightGreenCar
	]
	$BGButtons/NextButton.connect("pressed", Callable(self, "_on_next_button_pressed"))
	$BGButtons/BackButton.connect("pressed", Callable(self, "_on_back_button_pressed"))
	
	# Изначально показываем только первую машину
	update_car_visibility()

func update_car_visibility():
	# Сначала скрываем все машины
	for car in cars:
		car.visible = false
	
	# Показываем только текущую машину
	cars[current_car_index].visible = true

func _on_next_button_pressed():
	current_car_index += 1
	if current_car_index >= cars.size():
		current_car_index = 0  # Циклическое переключение
	
	update_car_visibility()
	
	# Сохраняем выбранную машину
	save_selected_car()

func _on_back_button_pressed():
	current_car_index -= 1
	if current_car_index < 0:
		current_car_index = cars.size() - 1  # Циклическое переключение
	
	update_car_visibility()
	
	# Сохраняем выбранную машину
	save_selected_car()

func save_selected_car():
	# Определяем имя выбранной машины
	var car_name = ""
	match current_car_index:
		0: car_name = "OrangeCar"
		1: car_name = "GreenCar"
		2: car_name = "LightGreenCar"
	
	# Сохраняем в ProgressManager
	ProgressManager.selected_car = car_name
	ProgressManager.save_progress()

func _on_back_to_level_button_pressed():
	# Возвращаемся к выбору уровня
	get_tree().change_scene_to_file("res://scenes/menu/scn_level.tscn")
