class_name InputHandler
var commands := {}

func register(key: String, command: Callable): commands[key] = command
func execute(key: String): if commands.has(key): commands[key].call()
