extends Node

enum DICE_TYPE {
	NUMBER, MULTIPLIER, ELEMENT, WEAPON
}	

var ActiveDice: Array = [
	Dice.new(DICE_TYPE.NUMBER),
	Dice.new(DICE_TYPE.ELEMENT),
	Dice.new(DICE_TYPE.ELEMENT),
	Dice.new(DICE_TYPE.ELEMENT),
	Dice.new(DICE_TYPE.ELEMENT),
	Dice.new(DICE_TYPE.ELEMENT),
]

func add_dice(newDice: Dice) -> void:
	ActiveDice.append(newDice)

var DiceValue = []

func add_dice_value(diceValue, index) -> void:
	# check if index exist
	if DiceValue.size() > index:
		DiceValue[index] = diceValue
	
	
func reset_dice_value() -> void:
	for i in range(DiceValue.size()):
		DiceValue[i] = 0
