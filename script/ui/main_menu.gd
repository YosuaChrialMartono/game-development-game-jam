extends MarginContainer
@onready var button_click: AudioStreamPlayer2D = $ButtonClick

func _on_new_game_button_pressed() -> void:
	button_click.play()
	GameManager.startNewGame()

func _on_exit_button_pressed() -> void:
	button_click.play()
	get_tree().quit()
