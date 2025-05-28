extends Node

@onready var is_rolling = false

@onready var _level: int = 0
@onready var win_level: int = 8
@onready var is_endless_mode = false
@onready var _level_modifier = 2
const LEVEL_SCENE = preload("res://scenes/levels/Level.tscn")
const MAIN_MENU_SCENE = preload("res://scenes/ui/MainMenu.tscn")

var attack_point_value = 0
var mult_point_value = 1

func _rollDice() -> void:
	is_rolling = true # Lock rolling
	for dice: Dice in DiceGlobal.rendered_active_dice:
		dice.roll_dice()
	is_rolling = false # Unlock rolling after completion
	
func calculateDamage() -> int:
	var attack_point = 0
	var mult_point = 1

	print_debug(DiceGlobal.dice_value)

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
			mult_point += 1
		elif value == "x2":
			mult_point += 2
		elif value == "x3":
			mult_point += 3
	
	attack_point_value = attack_point
	mult_point_value = mult_point

	return attack_point * mult_point
	
func roll_dice():
	if not DiceGlobal.is_rolling:
		DiceGlobal.reset_dice_value()
		print_debug("rolling dice")
		_rollDice()
	
func enemies_attack():
	PlayersGlobal.damagePlayer(EnemiesGlobal.active_enemy.enemy_resource.attack_damage)

func startNewGame() -> void:
	_level = 0
	reset_damage_counter()
	PlayersGlobal.setupNewGame()
	DiceGlobal.setupNewGame()
	HeroGlobal.setupNewGame()
	# _debug_level_create_dice()
	# _debug_level_create_hero()
	assign_dice()
	assign_hero_card()

	initNewLevel()

func reset_damage_counter():
	attack_point_value = 0
	mult_point_value = 1

func set_enemy():
	EnemiesGlobal.set_enemy()
	var enemyHP = EnemiesGlobal.get_enemy_hp()
	EnemiesGlobal.set_enemy_hp(enemyHP * (_level_modifier * _level))


func initNewLevel() -> void:
	_level += 1
	set_enemy()
	# Reset player shield
	PlayersGlobal.shield = PlayersGlobal.BASE_SHIELD
	reset_damage_counter()
	
	# Random choice for dice or hero, change later
	var randomChoice = randi_range(0, 1)
	if randomChoice == 0:
		assign_dice()
	else:
		assign_hero_card()

	if EnemiesGlobal.active_enemy:
		SceneTransition.change_scene(LEVEL_SCENE)

func get_current_level() -> int:
	return _level

func player_attack():
	var damage = calculateDamage()
	EnemiesGlobal.damage_enemy(damage)

func end_turn():
	player_attack()
	if EnemiesGlobal.get_enemy_hp() <= 0:
		await EnemiesGlobal.destroy_enemy()
	else:
		enemies_attack()

func assign_dice():
	var avail_dice = [Dice.DICE_TYPE.NUMBER, Dice.DICE_TYPE.MULTIPLIER]
	print_debug(avail_dice)
	DiceGlobal.add_active_dice_type(avail_dice.pick_random())

func assign_hero_card():
	print_debug(HeroGlobal.avail_hero_cards.pick_random())
	HeroGlobal.add_hero(HeroGlobal.avail_hero_cards.pick_random())

func _debug_level_create_dice():
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.NUMBER)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.ELEMENT)
	DiceGlobal.add_active_dice_type(Dice.DICE_TYPE.MULTIPLIER)

func _debug_level_create_hero():
	HeroGlobal.add_hero("warrior")
	HeroGlobal.add_hero("shield")
	HeroGlobal.add_hero("archer")
	HeroGlobal.add_hero("wizard")
	HeroGlobal.add_hero("warrior")
	HeroGlobal.add_hero("priest")

# func _ready() -> void:	

func activateEndlessMode():
	is_endless_mode = true

func _physics_process(delta: float) -> void:
	calculateDamage()
