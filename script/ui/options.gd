extends Control

@onready var root: Control = $"."
@onready var confirmation_pop_up: MarginContainer = $ConfirmationPopUp
@onready var confirmation_pop_up_bg: ColorRect = $ConfirmationPopUpBG

func _on_continue_button_pressed() -> void:
	root.visible = false


func _on_main_menu_button_pressed() -> void:
	confirmation_pop_up_bg.visible = true
	confirmation_pop_up.visible = true

func _on_no_button_pressed() -> void:
	root.visible = false


func _on_yes_button_pressed() -> void:
	get_tree().change_scene_to_packed(GameManager.MAIN_MENU_SCENE)
