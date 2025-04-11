extends StaticBody2D

class_name Dice

enum DICE_TYPE {
	NUMBER, MULTIPLIER, ELEMENT, WEAPON
}	

const dice_type_enum = DICE_TYPE
const SIZE := Vector2(128,128)

@export var type: dice_type_enum 
@export var dice_index: int
@onready var animated_sprite: AnimatedSprite2D 

@onready var number_dice_sprite = $NumberDiceSprite
@onready var mult_dice_sprite = $MultiplierDiceSprite
@onready var element_dice_sprite = $ElementalDiceSprite

func _ready() -> void:
	if type == dice_type_enum.NUMBER:
		animated_sprite = number_dice_sprite
	elif type == dice_type_enum.MULTIPLIER:
		animated_sprite = mult_dice_sprite
	elif type == dice_type_enum.ELEMENT:
		animated_sprite = element_dice_sprite
	
	animated_sprite.visible = true
	$BlankSprite.visible = false

#func _process(delta) -> void:
	# Ensure input is only detected once per press
	#if Input.is_action_just_pressed("ui_accept") and not is_rolling:
		#print_debug("rolling dice")
		#roll_dice()


func roll_dice() -> void:
	animated_sprite.play("default")
	await get_tree().create_timer(1.0).timeout  # Simulate rolling time

	var random_number = randi_range(1, 6)
	var dice_roll_value = get_value(random_number)
	animated_sprite.play(str(dice_roll_value))

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
