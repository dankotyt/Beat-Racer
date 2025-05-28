@tool
extends TextureButton

signal level_selected(level_num: int)

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
		var err = pressed.connect(_on_pressed)
		if not locked && has_node("Label"):
			$Label.text = str(level_num)
		
func _on_pressed():
	print("Pressed")
	if not locked:
		level_selected.emit(level_num)
		get_tree().change_scene_to_file("res://scenes/menu/scn_choose_car.tscn") 
