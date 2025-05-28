extends Control

@onready var shop_scene: Control = $"."
@onready var button_click: AudioStreamPlayer2D = $ButtonClick

@onready var confirmation_pop_up_bg: ColorRect = $ConfirmationPopUpBG
@onready var confirmation_pop_up: MarginContainer = $ConfirmationPopUp

var choice = 0

# Dice button
func _on_continue_button_pressed() -> void:
	button_click.play()
	confirmation_pop_up_bg.visible = true
	confirmation_pop_up.visible = true
	choice = 0

# Card button
func _on_main_menu_button_pressed() -> void:
	button_click.play()
	confirmation_pop_up_bg.visible = true
	confirmation_pop_up.visible = true
	choice = 1


func _on_no_button_pressed() -> void:
	button_click.play()
	confirmation_pop_up_bg.visible = false
	confirmation_pop_up.visible = false


func _on_yes_button_pressed() -> void:
	button_click.play()
	if choice == 0:
		GameManager.assign_dice()
	elif choice == 1:
		GameManager.assign_hero_card()
	
	shop_scene.hide()
	GameManager.initNewLevel()
