extends Node

@onready var _is_rolling = false

@onready var _level: int = 0
@onready var win_level: int = 8
@onready var _level_modifier = 2
const LEVEL_SCENE = preload("res://scenes/levels/Level.tscn")

var attack_point_value = 0
var mult_point_value = 0

func _rollDice() -> void:
	_is_rolling = true # Lock rolling
	for dice: Dice in DiceGlobal.active_dice:
		dice.roll_dice()
	_is_rolling = false # Unlock rolling after completion
	
func calculateDamage() -> int:
	var attack_point = 0
	var mult_point = 0

	# Count all number dice value
	for value in DiceGlobal.dice_value:
		if value is int:
			attack_point += int(value)
	
	# Count all hero value
	for hero in HeroGlobal.active_hero:
		var hero_info = HeroGlobal.get_hero_info(hero)
		hero_info = hero_info["info"]
		if hero_info.has("attack"):
			attack_point += hero_info["attack"]


	# Multiply all value
	for value in DiceGlobal.dice_value:
		if value is int:
			continue
		if value == "x1":
			mult_point = 1
		elif value == "x2":
			mult_point = 2
		elif value == "x3":
			mult_point = 3
	
	attack_point_value = attack_point
	mult_point_value = mult_point

	return attack_point * mult_point
	
func initNewLevel() -> void:
	_level += 1
	EnemiesGlobal.set_enemy()
	var enemyHP = EnemiesGlobal.get_enemy_hp()
	print_debug(enemyHP)
	EnemiesGlobal.set_enemy_hp(enemyHP * (_level_modifier * _level))
	
func player_attack():
	if not _is_rolling:
		DiceGlobal.reset_dice_value()
		print_debug("rolling dice")
		_rollDice()
		
		await get_tree().create_timer(1.0).timeout
		
		var damage = calculateDamage()
		EnemiesGlobal.damage_enemy(damage)
	
func enemies_attack():
	PlayersGlobal.damagePlayer(EnemiesGlobal.active_enemy.enemy_resource.attack_damage)

func get_current_level() -> int:
	return _level

func end_turn():
	player_attack()
	await get_tree().create_timer(1.0).timeout
	if EnemiesGlobal.get_enemy_hp() <= 0:
		initNewLevel()
	else:
		enemies_attack()


#func _process(delta) -> void:
	# Ensure input is only detected once per press
func _ready() -> void:
	DiceGlobal.add_dice(Dice.DICE_TYPE.NUMBER)
	DiceGlobal.add_dice(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_dice(Dice.DICE_TYPE.MULTIPLIER)
	
	# HeroGlobal.add_hero("warrior")
	# HeroGlobal.add_hero("warrior")
	# HeroGlobal.add_hero("warrior")
	# HeroGlobal.add_hero("warrior")
	# HeroGlobal.add_hero("warrior")
	HeroGlobal.add_hero("priest")
