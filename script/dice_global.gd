extends Node

const INIT_NUMBER_VALUES = [1, 2, 3, 4, 5, 6]
const INIT_MULTIPLIER_VALUES = ["x1", "x2", "x3"]
const INIT_ELEMENT_VALUES = ["FIRE", "ICE", "EARTH", "AIR"]

const BASE_MAX_DICE_HAND_SIZE = 3

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

var rendered_active_dice: Array[Dice] = []
var active_dice_info: Array[Dice.DICE_TYPE] = []

var max_dice_hand_size: int = BASE_MAX_DICE_HAND_SIZE

var is_rolling = false

func add_rendered_dice(dice: Dice) -> void:
	rendered_active_dice.append(dice)

func add_active_dice_type(type: Dice.DICE_TYPE):
	active_dice_info.append(type)

var dice_value = []

func add_dice_value(new_value, index) -> void:
	# check if index exist
	if dice_value.size() > index:
		dice_value[index] = new_value
	
func reset_dice_value() -> void:
	for i in range(dice_value.size()):
		dice_value[i] = 0

func resetRenderedDice():
	rendered_active_dice = []

func setupNewGame():
	active_dice_info = []
	rendered_active_dice = []
	max_dice_hand_size = BASE_MAX_DICE_HAND_SIZE
	dice_value = []
