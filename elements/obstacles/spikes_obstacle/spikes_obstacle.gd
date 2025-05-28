# elements/obstacles/spikes_obstacle/spikes_obstacle.gd
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
		GameManager.state = GameManager.GameState.GAME_OVER
		GameManager.emit_signal("game_over")
