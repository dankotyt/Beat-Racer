extends CharacterBody2D

@export var max_speed: float = 500.0
@export var acceleration: float = 800.0
@export var lateral_speed: float = 200.0
@export var rotation_speed: float = 2.0          # Скорость поворота при движении
@export var return_to_straight_speed: float = 3.0 # Скорость возврата к прямому положению
@export var mass: float = 1.5                   # Вес объекта (1 = стандартный, >1 = тяжелее)
@export var drag: float = 0.1                    # Сопротивление движению (0 = нет, 1 = сильное)

var current_speed: float = 0.0
var current_lateral_speed: float = 0.0
var initial_rotation: float = 0.0
var target_rotation: float = 0.0  # Целевой угол для выравнивания

func _ready():
	initial_rotation = rotation
	target_rotation = initial_rotation
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Получаем ввод управления
	var move_input = Input.get_axis("ui_down", "ui_up")
	var turn_input = Input.get_axis("ui_left", "ui_right")
	
	# Управление передней/задней скоростью (с учётом массы)
	var target_speed = move_input * max_speed / mass  # Чем больше масса, тем медленнее разгон
	current_speed = move_toward(current_speed, target_speed, (acceleration / mass) * delta)
	
	# Управление боковым движением (также зависит от массы)
	var target_lateral_speed = turn_input * lateral_speed / mass
	current_lateral_speed = move_toward(current_lateral_speed, target_lateral_speed, (acceleration / mass) * delta)
	
	# Управление поворотом (масса влияет на скорость поворота)
	if abs(turn_input) > 0.1 and abs(current_speed) > 10:
		target_rotation = initial_rotation + deg_to_rad(turn_input * 60.0)  # Макс 20 градусов
	else:
		target_rotation = initial_rotation
	
	# Плавный поворот (чем больше масса, тем медленнее поворот)
	rotation = lerp_angle(rotation, target_rotation, (return_to_straight_speed / mass) * delta)
	
	# Применение движения
	var forward_velocity = Vector2(0, -current_speed).rotated(initial_rotation)
	var lateral_velocity = Vector2(current_lateral_speed, 0).rotated(initial_rotation)
	velocity = forward_velocity + lateral_velocity
	
	# Добавляем "сопротивление" (drag) для имитации инерции
	velocity *= (1.0 - drag * delta)
	
	move_and_slide()
