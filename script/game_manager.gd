extends Node

@onready var is_rolling = false

func rollDice() -> void:
	is_rolling = true  # Lock rolling
	print_debug(DiceGlobal.active_dice)
	for dice:Dice in DiceGlobal.active_dice:
		dice.roll_dice()
	is_rolling = false  # Unlock rolling after completion
	
func calculateDamage() -> int:
	var total_value = 0
	# Count all number value
	for value in DiceGlobal.dice_value:
		if value is int:
			print_debug(value)
			total_value += int(value)
	
	# Multiply all value
	for value in DiceGlobal.dice_value:
		if value is int:
			continue
		print_debug(value)
		print_debug(total_value)
		if value == "x1":
			total_value = total_value * 1
		elif  value == "x2":
			total_value = total_value * 2
		elif value == "x3":
			total_value = total_value * 3
	
	print_debug(total_value)
	return total_value
	
func _process(delta) -> void:
	# Ensure input is only detected once per press
	if Input.is_action_just_pressed("ui_accept") and not is_rolling:
		DiceGlobal.reset_dice_value()
		print_debug("rolling dice")
		rollDice()
		
		await get_tree().create_timer(1.0).timeout
		
		var damage = calculateDamage()
		EnemiesGlobal.damage_enemy(damage)

func _ready() -> void:
	DiceGlobal.add_dice(Dice.DICE_TYPE.NUMBER)
	DiceGlobal.add_dice(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_dice(Dice.DICE_TYPE.MULTIPLIER)
	
	
	HeroGlobal.add_hero(HeroGlobal.HERO_TYPE.WARRIOR)
	HeroGlobal.add_hero(HeroGlobal.HERO_TYPE.WARRIOR)
	HeroGlobal.add_hero(HeroGlobal.HERO_TYPE.WARRIOR)
	HeroGlobal.add_hero(HeroGlobal.HERO_TYPE.WARRIOR)
	HeroGlobal.add_hero(HeroGlobal.HERO_TYPE.WARRIOR)
	HeroGlobal.add_hero(HeroGlobal.HERO_TYPE.WARRIOR)
