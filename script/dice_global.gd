extends Node

const INIT_NUMBER_VALUES = [1,2,3,4,5,6]
const INIT_MULTIPLIER_VALUES = ["x1", "x2", "x3"]
const INIT_ELEMENT_VALUES = ["FIRE", "ICE", "EARTH", "AIR"]

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

var active_dice: Array = []

func add_dice(dice_type: Dice.DICE_TYPE) -> void:
	var new_dice = DICE_SCENE.instantiate()
	new_dice.dice_index = active_dice.size()
	new_dice.type = dice_type
	active_dice.append(new_dice)

var dice_value = []

var current_dice_score = 0
var current_elemental = []

func add_dice_value(new_value, index) -> void:
	# check if index exist
	if dice_value.size() > index:
		dice_value[index] = new_value
	
	
func reset_dice_value() -> void:
	for i in range(dice_value.size()):
		dice_value[i] = 0
