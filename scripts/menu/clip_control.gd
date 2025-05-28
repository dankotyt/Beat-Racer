extends Control

signal initialized

@onready var grid_container = %GridContainer

func _ready():
	if grid_container:
		setup_level_box()
		connect_level_selected_to_level_box()
	else:
		push_error("GridContainer not found!")
	initialized.emit()

func setup_level_box():
	# Проверяем все GridContainer и их LevelBox
	for grid in grid_container.get_children():
		if not grid is GridContainer:
			continue
			
		for i in range(grid.get_child_count()):
			var box = grid.get_child(i)
			if box.has_method("set_level_num"):
				box.level_num = i + 1 + grid.get_child_count() * grid.get_index()
				box.locked = true 
	
	# Разблокируем первый уровень
	if grid_container.get_child_count() > 0:
		var first_grid = grid_container.get_child(0)
		if first_grid.get_child_count() > 0:
			var first_box = first_grid.get_child(0)
			first_box.locked = false

#func connect_level_selected_to_level_box():
	#for grid in grid_container.get_children():
		#if not grid is GridContainer:
			#continue
			#
		#for box in grid.get_children():
			#if box.has_signal("level_selected"):
				#box.connect("level_selected", _on_level_selected)
				
func connect_level_selected_to_level_box():
	for grid in grid_container.get_children():
		for box in grid.get_children():
			if box.has_signal("level_selected"):
				var err = box.level_selected.connect(_on_level_selected)
				if err != OK:
					print("Connection FAILED for: ", box.name)
				else:
					print("Button ", box.name, " has NO level_selected signal!")

func _on_level_selected(level_num: int):
	print("Pressed")
	ProgressManager.selected_level = level_num
	
	var car_select_scene = "res://scenes/base/scn_choose_car.tscn"
	
	if ResourceLoader.exists(car_select_scene):
		get_tree().change_scene_to_file(car_select_scene)
	else:
		push_error("Scene not found: ", car_select_scene)
