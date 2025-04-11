extends MarginContainer

func _on_new_game_button_pressed() -> void:
	GameManager.startNewGame()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
