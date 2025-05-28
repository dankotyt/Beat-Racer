# elements/finish_line/finish_line.gd
extends Area2D

var speed := 500.0

func _process(delta):
	if GameManager.state != GameManager.GameState.PLAYING:
		return

	position.y += speed * delta

	if position.y > 1500:
		queue_free()


func _on_body_entered(body):
	if body.name == "Player":
		GameManager.state = GameManager.GameState.WIN
		if GameManager.difficulty == "easy":
			GameManager.difficulty = "medium"
		if GameManager.difficulty == "medium":
			GameManager.difficulty = "hard"
		GameManager.emit_signal("win")
