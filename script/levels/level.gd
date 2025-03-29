extends Node

@onready var score = $Score

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

func renderDice() -> void:
	for i:int in range(DiceGlobal.ActiveDice.size()):
		var child = DICE_SCENE.instantiate()
		child.position = Vector2(i * 150, 0)
		child.name = "Dice" + str(i)
		child.dice_index = i
		add_child(child)

func _input(event):
	# Reset dice values
	if Input.is_action_just_pressed("ui_accept"):
		DiceGlobal.reset_dice_value()

func _ready() -> void:
	print_debug("level ready")
	renderDice()
	for i:int in range(DiceGlobal.ActiveDice.size()):
		DiceGlobal.DiceValue.append(0)

func _process(delta: float) -> void:
	#var totalValue = 0
	#for value in DiceGlobal.DiceValue:
		#if value is int:
			#totalValue += value
	#score.text = str(totalValue)
	#print_debug(DiceGlobal.DiceValue)
	var valueText = ""
	for value in DiceGlobal.DiceValue:
		valueText += str(value)
	score.text = valueText
