extends Node

@onready var is_rolling = false

@onready var hp: int = 10
@onready var shield: int = 0

@onready var level: int = 0
@onready var level_modifier = 2
const LEVEL_SCENE = preload("res://scenes/levels/Level.tscn")

func rollDice() -> void:
	is_rolling = true # Lock rolling
	for dice: Dice in DiceGlobal.active_dice:
		dice.roll_dice()
	is_rolling = false # Unlock rolling after completion
	
func calculateDamage() -> int:
	var total_value = 0
	# Count all number dice value
	for value in DiceGlobal.dice_value:
		if value is int:
			total_value += int(value)
	
	# Count all hero value
	for hero in HeroGlobal.active_hero:
		var hero_info = HeroGlobal.get_hero_info(hero)
		hero_info = hero_info["info"]
		if hero_info.has("attack"):
			total_value += hero_info["attack"]

	# Multiply all value
	for value in DiceGlobal.dice_value:
		if value is int:
			continue
		if value == "x1":
			total_value = total_value * 1
		elif value == "x2":
			total_value = total_value * 2
		elif value == "x3":
			total_value = total_value * 3
	
	return total_value
	
func initNewLevel() -> void:
	level += 1
	EnemiesGlobal.set_enemy()
	var enemy = EnemiesGlobal.active_enemy
	enemy.enemy_resource.hp = hp * (level_modifier * level)
	
func attack():
	if not is_rolling:
		DiceGlobal.reset_dice_value()
		print_debug("rolling dice")
		rollDice()
		
		await get_tree().create_timer(1.0).timeout
		
		var damage = calculateDamage()
		EnemiesGlobal.damage_enemy(damage)
	
#func _process(delta) -> void:
	# Ensure input is only detected once per press


func _ready() -> void:
	DiceGlobal.add_dice(Dice.DICE_TYPE.NUMBER)
	DiceGlobal.add_dice(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_dice(Dice.DICE_TYPE.MULTIPLIER)
	
	HeroGlobal.add_hero("warrior")
	HeroGlobal.add_hero("priest")
