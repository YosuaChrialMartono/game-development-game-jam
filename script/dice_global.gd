extends Node

const INIT_NUMBER_VALUES = [1,2,3,4,5,6]
const INIT_MULTIPLIER_VALUES = ["x1.5", "x2", "x3"]
const INIT_ELEMENT_VALUES = ["FIRE", "ICE", "EARTH", "AIR"]

var active_dice: Array = [
	Dice.DICE_TYPE.NUMBER,
	Dice.DICE_TYPE.ELEMENT,
	Dice.DICE_TYPE.MULTIPLIER,
]

func add_dice(new_dice: Dice) -> void:
	active_dice.append(new_dice)

var dice_value = []

func add_dice_value(new_value, index) -> void:
	# check if index exist
	if dice_value.size() > index:
		dice_value[index] = new_value
	
	
func reset_dice_value() -> void:
	for i in range(dice_value.size()):
		dice_value[i] = 0
