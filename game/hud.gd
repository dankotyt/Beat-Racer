extends CanvasLayer

@onready var status_label = $StatusLabel

func _ready():
		GameManager.connect("game_over", _on_game_over)
		GameManager.connect("win", _on_win)

func _on_game_over():
		await get_tree().create_timer(1.0).timeout
		GameManager.show_lose_screen()

func _on_win():
		await get_tree().create_timer(1.0).timeout
		GameManager.show_win_screen()
