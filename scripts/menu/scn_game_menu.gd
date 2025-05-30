extends Node2D

func _ready():
	var start_button = $VBoxContainer/StartButton
	var settings_button = $VBoxContainer/SettingsButton
	var exit_button = $VBoxContainer/ExitButton
	
	start_button.pressed.connect(_on_button_pressed.bind("start"))
	settings_button.pressed.connect(_on_button_pressed.bind("settings"))
	exit_button.pressed.connect(_on_button_pressed.bind("exit"))
	
	$VBoxContainer.add_to_group("ui_elements")
	$BGButtons.add_to_group("ui_elements")
	$Label.add_to_group("ui_elements")
	
	if not AudioManager.instance.is_music_playing:
		AudioManager.instance.set_music_state(true)
		AudioManager.instance.set_volume(0.2)

func _on_button_pressed(command_name: String):
	var command = GameCommands.create_command(command_name, self)
	command.execute()
