# command.gd (Паттерн Команда)
class_name GameCommands

# Базовый класс команды
class BaseCommand:
	var _scene: Node
	
	func _init(scene: Node):
		_scene = scene
	
	func execute():
		pass

# Конкретные команды
class StartGameCommand extends BaseCommand:
	func execute():
		print("Выбор уровня")
		_scene.get_tree().call_group("ui_elements", "queue_free")
		var level_menu = load("res://scenes/menu/scn_level.tscn").instantiate()
		_scene.add_child(level_menu)

class OpenSettingsCommand extends BaseCommand:
	func execute():
		print("Открытие настроек")
		_scene.get_tree().call_group("ui_elements", "queue_free")
		var settings_scene = load("res://scenes/menu/scn_settings.tscn").instantiate()
		_scene.add_child(settings_scene)

class ExitGameCommand extends BaseCommand:
	func execute():
		print("Выход из игры")
		AudioManager.set_music_state(false)
		_scene.get_tree().quit()

# Фабрика команд
static func create_command(command_name: String, current_scene: Node) -> BaseCommand:
	match command_name:
		"start":
			return StartGameCommand.new(current_scene)
		"settings":
			return OpenSettingsCommand.new(current_scene)
		"exit":
			return ExitGameCommand.new(current_scene)
		_:
			return BaseCommand.new(current_scene)
