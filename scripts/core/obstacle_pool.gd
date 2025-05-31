class_name ObstaclePool
extends Node

const CAR_SCENE = preload("res://elements/obstacles/car_obstacle/car_obstacle.tscn")
const SPIKES_SCENE = preload("res://elements/obstacles/spikes_obstacle/spikes_obstacle.tscn")
const TREE_LEFT_SCENE = preload("res://elements/obstacles/tree_obstacle/tree_obstacle_left.tscn")
const TREE_RIGHT_SCENE = preload("res://elements/obstacles/tree_obstacle/tree_obstacle_right.tscn")

var car_pool: Array = []
var spikes_pool: Array = []
var tree_left_pool: Array = []
var tree_right_pool: Array = []

func spawn_obstacle(type: String) -> Node2D:
	match type:
		"car":
			if car_pool.is_empty():
				return create_new_obstacle(type)
			var obstacle = car_pool.pop_back()
			obstacle.show()
			return obstacle
		"spikes":
			if spikes_pool.is_empty():
				return create_new_obstacle(type)
			var obstacle = spikes_pool.pop_back()
			obstacle.show()
			return obstacle
		"tree_left":
			if tree_left_pool.is_empty():
				return create_new_obstacle(type)
			var obstacle = tree_left_pool.pop_back()
			obstacle.show()
			return obstacle
		"tree_right":
			if tree_right_pool.is_empty():
				return create_new_obstacle(type)
			var obstacle = tree_right_pool.pop_back()
			obstacle.show()
			return obstacle
		_:
			push_error("Unknown obstacle type: " + type)
			return null

func despawn_obstacle(obstacle: Node2D):
	obstacle.hide()
	obstacle.position = Vector2.ZERO
	
	var scene_name = obstacle.get_scene_file_path().get_file()
	
	if "car_obstacle" in scene_name:
		car_pool.append(obstacle)
	elif "spikes_obstacle" in scene_name:
		spikes_pool.append(obstacle)
	elif "tree_obstacle_left" in scene_name:
		tree_left_pool.append(obstacle)
	elif "tree_obstacle_right" in scene_name:
		tree_right_pool.append(obstacle)
	else:
		push_error("Unknown obstacle type in despawn: " + scene_name)
		obstacle.queue_free()

# Фабричный метод
func create_new_obstacle(type: String) -> Node2D:
	var obstacle: Node2D
	
	match type:
		"car":
			obstacle = CAR_SCENE.instantiate()
			car_pool.append(obstacle)
		"spikes":
			obstacle = SPIKES_SCENE.instantiate()
			spikes_pool.append(obstacle)
		"tree_left":
			obstacle = TREE_LEFT_SCENE.instantiate()
			tree_left_pool.append(obstacle)
		"tree_right":
			obstacle = TREE_RIGHT_SCENE.instantiate()
			tree_right_pool.append(obstacle)
		_:
			push_error("Unknown obstacle type in create: " + type)
			return null
	
	add_child(obstacle)
	obstacle.hide()  # Сначала создаем скрытым
	return obstacle
