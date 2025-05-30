extends Area2D

var speed := 700.0
var wiggle_amplitude := 50.0
var wiggle_frequency := 2.0
var base_x := 0.0
var time := 0.0

func _ready():
		base_x = position.x
		time = randf() * PI * 2  # случайный начальный фазовый сдвиг

func _process(delta):
		if GameManager.state != GameManager.GameState.PLAYING:
				return

		time += delta

		# Движение по Y
		position.y += speed * delta

		# Виляние по X с помощью синуса
		position.x = base_x + sin(time * wiggle_frequency) * wiggle_amplitude

		if position.y > 1500:
				queue_free()

func _on_body_entered(body):
		if body.name == "Player":
				GameManager.state = GameManager.GameState.GAME_OVER
				GameManager.emit_signal("game_over")


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
