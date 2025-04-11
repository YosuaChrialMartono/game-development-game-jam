extends Control

@onready var root: Control = $"."
@onready var confirmation_pop_up: MarginContainer = $ConfirmationPopUp
@onready var confirmation_pop_up_bg: ColorRect = $ConfirmationPopUpBG
@onready var button_click: AudioStreamPlayer2D = $ButtonClick

func _on_continue_button_pressed() -> void:
	button_click.play()
	root.visible = false


func _on_main_menu_button_pressed() -> void:
	button_click.play()
	confirmation_pop_up_bg.visible = true
	confirmation_pop_up.visible = true

func _on_no_button_pressed() -> void:
	button_click.play()
	root.visible = false


func _on_yes_button_pressed() -> void:
	button_click.play()
	SceneTransition.change_scene(GameManager.MAIN_MENU_SCENE)
