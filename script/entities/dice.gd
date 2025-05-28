extends StaticBody2D

class_name Dice

enum DICE_TYPE {
	NUMBER, MULTIPLIER, ELEMENT, WEAPON
}

const dice_type_enum = DICE_TYPE
const SIZE := Vector2(128, 128)

@export var type: dice_type_enum
@export var dice_index: int
@onready var animated_sprite: AnimatedSprite2D

@onready var number_dice_sprite = $NumberDiceSprite
@onready var mult_dice_sprite = $MultiplierDiceSprite
@onready var element_dice_sprite = $ElementalDiceSprite
@onready var dice_drop: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var dice_shuffle: AudioStreamPlayer2D = $DiceShuffle

func _ready() -> void:
	if type == dice_type_enum.NUMBER:
		animated_sprite = number_dice_sprite
	elif type == dice_type_enum.MULTIPLIER:
		animated_sprite = mult_dice_sprite
	elif type == dice_type_enum.ELEMENT:
		animated_sprite = element_dice_sprite
	
	animated_sprite.visible = true
	$BlankSprite.visible = false
	
	roll_dice()
	#var random_number = randi_range(1, 6)
	#var dice_roll_value = get_value(random_number)
	#animated_sprite.play(str(dice_roll_value))
	#DiceGlobal.add_dice_value(dice_roll_value, dice_index)
	#print_debug(DiceGlobal.dice_value)

func roll_dice() -> void:
	DiceGlobal.is_rolling = true
	animated_sprite.play("default")
	dice_shuffle.play()
	await get_tree().create_timer(1).timeout 
	dice_shuffle.stop()
	dice_drop.play()
	var random_number = randi_range(1, 6)
	var dice_roll_value = get_value(random_number)
	animated_sprite.play(str(dice_roll_value))
	DiceGlobal.is_rolling = false

	DiceGlobal.add_dice_value(dice_roll_value, dice_index)
	

func get_value(index):
	if type == dice_type_enum.NUMBER:
		return index
	elif type == dice_type_enum.MULTIPLIER:
		return DiceGlobal.INIT_MULTIPLIER_VALUES[index % 3]
	elif type == dice_type_enum.ELEMENT:
		return DiceGlobal.INIT_ELEMENT_VALUES[index % 4]
	else:
		return ""
