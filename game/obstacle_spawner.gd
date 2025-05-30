### game/obstacle_spawner.gd
extends Node
#
#var spawn_timer := Timer.new()
#var x_min := 380
#var x_max := 1170
#
#const OBSTACLES = {
	#"easy": [
		#preload("res://elements/obstacles/spikes_obstacle/spikes_obstacle.tscn"),
		#preload("res://elements/obstacles/Rock_obstacle/rock_obstacle.tscn"),
		#preload("res://elements/obstacles/tree_obstacle/tree_obstacle_left.tscn"),
		#preload("res://elements/obstacles/tree_obstacle/tree_obstacle_right.tscn"),
		#preload("res://elements/obstacles/Police_car_obstacle/police_car.tscn")
	#],
	#"medium": [
		#preload("res://elements/obstacles/spikes_obstacle/spikes_obstacle.tscn"),
		#preload("res://elements/obstacles/Rock_obstacle/rock_obstacle.tscn"),
		#preload("res://elements/obstacles/tree_obstacle/tree_obstacle_left.tscn"),
		#preload("res://elements/obstacles/tree_obstacle/tree_obstacle_right.tscn"),
		#preload("res://elements/obstacles/Police_car_obstacle/police_car.tscn"),
		#preload("res://elements/obstacles/car_obstacle/car_obstacle_UAZ.tscn"),
		#preload("res://elements/obstacles/car_obstacle/car_obstacle_VAN.tscn"),
		#preload("res://elements/obstacles/car_obstacle/bus_obstacle.tscn")
	#],
	#"hard": [
		#preload("res://elements/obstacles/spikes_obstacle/spikes_obstacle.tscn"),
		#preload("res://elements/obstacles/Rock_obstacle/rock_obstacle.tscn"),
		#preload("res://elements/obstacles/tree_obstacle/tree_obstacle_left.tscn"),
		#preload("res://elements/obstacles/tree_obstacle/tree_obstacle_right.tscn"),
		#preload("res://elements/obstacles/car_obstacle/car_obstacle.tscn"),
		#preload("res://elements/obstacles/Police_car_obstacle/police_car.tscn"),
		#preload("res://elements/obstacles/car_obstacle/car_obstacle_UAZ.tscn"),
		#preload("res://elements/obstacles/car_obstacle/car_obstacle_VAN.tscn"),
		#preload("res://elements/obstacles/car_obstacle/bus_obstacle.tscn")
	#]
#}
#
#func _ready():
	#add_child(spawn_timer)
	#spawn_timer.timeout.connect(_on_spawn_timeout)
	#start_spawning()
#
#func start_spawning():
	#match GameManager.difficulty:
		#"easy":
			#spawn_timer.wait_time = 2.0
		#"medium":
			#spawn_timer.wait_time = 1.2
		#"hard":
			#spawn_timer.wait_time = 0.8
	#spawn_timer.start()
#
#func _on_spawn_timeout():
	#if GameManager.state != GameManager.GameState.PLAYING:
		#return
#
	#var pool = OBSTACLES[GameManager.difficulty]
	#var obstacle_scene = pool[randi() % pool.size()]
	#var obstacle = obstacle_scene.instantiate()
	#obstacle.position = Vector2(randi_range(x_min, x_max), -100)
	#get_tree().current_scene.add_child(obstacle)
