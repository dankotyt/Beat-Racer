extends Node2D

func _ready():
	var start_button = $VBoxContainer/StartButton
	var settings_button = $VBoxContainer/SettingsButton
	var exit_button = $VBoxContainer/ExitButton
	
	start_button.pressed.connect(_on_start_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	$VBoxContainer.add_to_group("ui_elements")
	$BGButtons.add_to_group("ui_elements")
	$Label.add_to_group("ui_elements")
	
	if not AudioManager.is_music_playing:
		AudioManager.set_music_state(true)
		AudioManager.set_volume(0.2)

func _on_start_button_pressed():
	print("Выбор уровня")
	get_tree().call_group("ui_elements", "queue_free")
	var level_menu = load("res://scenes/menu/scn_level.tscn").instantiate()
	add_child(level_menu)


func _on_settings_button_pressed():
	print("Открытие настроек")
	get_tree().call_group("ui_elements", "queue_free")
	var settings_scene = load("res://scenes/menu/scn_settings.tscn").instantiate()
	add_child(settings_scene)


func _on_exit_button_pressed():
	print("Выход из игры")
	AudioManager.set_music_state(false)
	get_tree().quit()
