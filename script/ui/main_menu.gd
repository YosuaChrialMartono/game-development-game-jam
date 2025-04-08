extends MarginContainer

const LEVEL_SCENE = preload("res://scenes/levels/Level.tscn")

func _on_new_game_button_pressed() -> void:
	GameManager.initNewLevel()
	get_tree().change_scene_to_packed(LEVEL_SCENE)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
