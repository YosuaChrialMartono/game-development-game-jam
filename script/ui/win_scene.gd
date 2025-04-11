extends Control

@onready var win_scene: Control = $"."

func _on_endless_mode_button_pressed() -> void:
	# Turn off this scene to continue with the level
	win_scene.visible = false
	GameManager.activateEndlessMode()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameManager.MAIN_MENU_SCENE)
