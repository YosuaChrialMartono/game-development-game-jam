extends StaticBody2D

class_name Dice

@export var dice_index : int = 0
@onready var type: DiceGlobal.DICE_TYPE
@onready var animated_sprite = $AnimatedSprite2D
@onready var diceScoreLabel = $DiceScore
	
func _init(typeConstructor:DiceGlobal.DICE_TYPE) -> void:
	var type: DiceGlobal.DICE_TYPE = typeConstructor

func _process(delta) -> void:
	# Ensure input is only detected once per press
	if Input.is_action_just_pressed("ui_accept") and not is_rolling:
		roll_dice()

var is_rolling = false  # Track if the dice are rolling
func roll_dice() -> void:
	is_rolling = true  # Lock rolling

	animated_sprite.play("default")
	await get_tree().create_timer(1.0).timeout  # Simulate rolling time

	var random_number = randi_range(1, 6)
	DiceGlobal.add_dice_value(random_number, dice_index)

	animated_sprite.play(str(random_number))

	# Ensure the label exists before modifying its text
	if diceScoreLabel:
		diceScoreLabel.text = str(random_number)

	is_rolling = false  # Unlock rolling after completion
