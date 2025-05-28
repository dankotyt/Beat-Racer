extends CharacterBody2D

@export var max_speed: float = 100.0
@export var acceleration: float = 700.0
@export var lateral_speed: float = 200.0
@export var rotation_speed: float = 2.0
@export var return_to_straight_speed: float = 3.0

var current_speed: float = 0.0
var current_lateral_speed: float = 0.0
var target_rotation: float = 0.0
var target: Node2D = null

func _ready():
	add_to_group("bot")
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]

func _physics_process(delta: float) -> void:
	if target == null:
		return

	# Получаем разницу по X — определяем, надо ли обгонять
	var offset_x = target.global_position.x - global_position.x
	var distance_y = global_position.y - target.global_position.y

	# Базовое движение вперёд
	var move_input := 1.0

	# Обгон: если слишком близко сзади, уходим вбок
	var turn_input := 0.0
	if distance_y < 100 and distance_y > 0:
		# Смещаемся вбок, чтобы объехать
		turn_input = -1.0 if offset_x > 0 else 1.0
	else:
		# Плавное выравнивание в сторону игрока
		turn_input = clamp(offset_x / 50.0, -1.0, 1.0)

	# Управление движением
	var target_speed = move_input * max_speed
	current_speed = move_toward(current_speed, target_speed, acceleration * delta)

	# Боковая скорость для обгона
	var target_lateral_speed = turn_input * lateral_speed
	current_lateral_speed = move_toward(current_lateral_speed, target_lateral_speed, acceleration * delta)

	# Поворот (используем rotation напрямую!)
	if abs(turn_input) > 0.1 and abs(current_speed) > 10:
		target_rotation = rotation + deg_to_rad(turn_input * 10.0)
	else:
		target_rotation = 0.0  # Прямо вверх

	# Плавный поворот
	rotation = lerp_angle(rotation, target_rotation, return_to_straight_speed * delta)

	# Движение по направлению взгляда
	var forward_velocity = Vector2(0, -current_speed).rotated(rotation)
	var lateral_velocity = Vector2(current_lateral_speed, 0).rotated(rotation)
	velocity = forward_velocity + lateral_velocity
	move_and_slide()
