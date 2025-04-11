extends Control
@onready var button_click: AudioStreamPlayer2D = $ButtonClick

func _on_restart_button_pressed() -> void:
	button_click.play()
	GameManager.startNewGame()

func _on_main_menu_button_pressed() -> void:
	button_click.play()
	SceneTransition.change_scene(GameManager.MAIN_MENU_SCENE)
