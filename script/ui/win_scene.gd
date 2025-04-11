extends Control

@onready var win_scene: Control = $"."
@onready var button_click: AudioStreamPlayer2D = $ButtonClick

func _on_endless_mode_button_pressed() -> void:
	# Turn off this scene to continue with the level
	button_click.play()
	win_scene.visible = false
	GameManager.activateEndlessMode()

func _on_main_menu_button_pressed() -> void:
	button_click.play()
	SceneTransition.change_scene(GameManager.MAIN_MENU_SCENE)
