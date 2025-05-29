class_name InputHandler

# Паттерн "Команда"
var commands := {}

# Постановка входящей команды в очередь
func register_command(key: String, command: Callable):
	commands[key] = command

# Исполнение команды
func execute_command(key: String):
	if commands.has(key):
		commands[key].call()

# Очистка очереди команд
func clear_commands():
	commands.clear()
