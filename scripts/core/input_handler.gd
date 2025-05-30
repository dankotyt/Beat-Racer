class_name InputHandler

var commands := {}

func register_command(key: String, command: Callable):
	commands[key] = command

func execute_command(key: String):
	if commands.has(key):
		commands[key].call()

func clear_commands():
	commands.clear()
