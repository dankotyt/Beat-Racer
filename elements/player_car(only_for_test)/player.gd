extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 800.0
@export var lateral_speed: float = 200.0
@export var rotation_speed: float = 2.0          # Скорость поворота при движении
@export var return_to_straight_speed: float = 3.0 # Скорость возврата к прямому положению

var current_speed: float = 0.0
var current_lateral_speed: float = 0.0
var initial_rotation: float = 0.0
var target_rotation: float = 0.0  # Целевой угол для выравнивания

@onready var sprite = $Player3  # Предполагая, что у вас есть Sprite2D для отображения машины

func _ready():
	initial_rotation = rotation
	target_rotation = initial_rotation
	load_car_texture()

func load_car_texture():
	# Загружаем текстуру из ProgressManager
	var progress_manager = get_node("/root/ProgressManager")
	if progress_manager and sprite:
		print("Loading car texture from: ", progress_manager.current_car_texture)
		var texture = load(progress_manager.current_car_texture)
		if texture:
			sprite.texture = texture

func _physics_process(delta: float) -> void:
	# Получаем ввод управления
	var move_input = Input.get_axis("ui_down", "ui_up")
	var turn_input = Input.get_axis("ui_left", "ui_right")
	
	# Управление передней/задней скоростью
	var target_speed = move_input * max_speed
	current_speed = move_toward(current_speed, target_speed, acceleration * delta)
	
	# Управление боковым движением
	var target_lateral_speed = turn_input * lateral_speed
	current_lateral_speed = move_toward(current_lateral_speed, target_lateral_speed, acceleration * delta)
	
	# Управление поворотом
	if abs(turn_input) > 0.1 and abs(current_speed) > 10:
		# Поворачиваем при движении
		target_rotation = initial_rotation + deg_to_rad(turn_input * 20.0)  # Макс 20 градусов
	else:
		# Плавно возвращаемся к исходному положению
		target_rotation = initial_rotation
	
	# Плавный поворот к целевому углу
	rotation = lerp_angle(rotation, target_rotation, return_to_straight_speed * delta)
	
	# Применение движения
	var forward_velocity = Vector2(0, -current_speed).rotated(initial_rotation)
	var lateral_velocity = Vector2(current_lateral_speed, 0).rotated(initial_rotation)
	velocity = forward_velocity + lateral_velocity
	move_and_slide()
