extends StaticBody2D

class_name Dice

const dice_type_enum = DiceGlobal.DICE_TYPE
const SIZE := Vector2(128,128)

@export var type: dice_type_enum 
@export var dice_index: int
@onready var animated_sprite: AnimatedSprite2D 
@onready var dice_score_label = $DiceScore 
@onready var is_rolling = false  # Track if the dice are rolling

@onready var number_dice_sprite = $NumberDiceSprite
@onready var mult_dice_sprite = $MultiplierDiceSprite
@onready var element_dice_sprite = $ElementalDiceSprite

func _ready() -> void:
	#print_debug("Dice READY: " + name)
	#print_debug("Type: ", type)
	#print_debug("Index: ", dice_index)
	#print_debug(dice_type_enum.NUMBER)
	#print_debug(dice_type_enum.MULTIPLIER)
	#print_debug(dice_type_enum.ELEMENT)
	
	if type == dice_type_enum.NUMBER:
		animated_sprite = number_dice_sprite
	elif type == dice_type_enum.MULTIPLIER:
		animated_sprite = mult_dice_sprite
	elif type == dice_type_enum.ELEMENT:
		animated_sprite = element_dice_sprite
	
	animated_sprite.visible = true
	$BlankSprite.visible = false

func _process(delta) -> void:
	# Ensure input is only detected once per press
	if Input.is_action_just_pressed("ui_accept") and not is_rolling:
		print_debug("rolling dice")
		roll_dice()


func roll_dice() -> void:
	is_rolling = true  # Lock rolling

	animated_sprite.play("default")
	await get_tree().create_timer(1.0).timeout  # Simulate rolling time

	var random_number = randi_range(1, 6)
	var dice_roll_value = get_value(random_number)
	print_debug(dice_roll_value)
	animated_sprite.play(dice_roll_value)

	# Ensure the label exists before modifying its text
	if dice_score_label:
		dice_score_label.text = dice_roll_value

	DiceGlobal.add_dice_value(dice_roll_value, dice_index)
	is_rolling = false  # Unlock rolling after completion

func get_value(index) -> String:
	if type == dice_type_enum.NUMBER:
		return str(index)
	elif type == dice_type_enum.MULTIPLIER:
		return DiceGlobal.INIT_MULTIPLIER_VALUES[index % 3]
	elif type == dice_type_enum.ELEMENT:
		return DiceGlobal.INIT_ELEMENT_VALUES[index % 4]
	else:
		return ""
