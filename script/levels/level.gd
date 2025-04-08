extends Node

@onready var score = $MarginContainer/Panel/MarginContainer/VBoxContainer/Score
@onready var dice_parent: Panel = $DiceParent
@onready var enemy_parent: Control = $EnemyParent

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 10
@export var x_sep := 56
@export var y_min := 50
@export var y_max := -50

@onready var card_manager = $CardManager
@onready var card_factory = $CardManager/CardFactory
@onready var hero_card_parent: Panel = $HeroCardParent
@onready var hero_card_hand = $CardManager/Hand

@onready var enemy_name: Label = $EnemyInfo/EnemyName
@onready var hp_bar: ProgressBar = $EnemyInfo/HPBar
@onready var shield_bar: ProgressBar = $EnemyInfo/ShieldBar

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

func _renderDice() -> void:
	var dice_count = DiceGlobal.active_dice.size()
	var spacing = 150
	
	# Calculate starting x position so dice are centered
	var total_width = (dice_count * Dice.SIZE.x) + (dice_count - 1) * spacing
	#var start_x = (x - total_width) / 2  # Centering logic
	
	var dice_num = 0
	for dice in DiceGlobal.active_dice:
		var child = dice
		dice.position = Vector2( 128 + dice_num * spacing, dice_parent.size.y / 2)  # 70% down the screen
		child.name = "Dice" + str(dice_num)
		dice_parent.add_child(child)
		dice_num += 1
		
	
		
func _renderHeroCard() -> void:
	var hero_card_list = ["warrior","warrior","warrior","warrior","warrior", "slime"]
	for card in hero_card_list:
		card_factory.create_card(card, hero_card_hand)

func _renderEnemy() -> void:
	var child: Enemy = EnemiesGlobal.active_enemy
	enemy_parent.add_child(child)


func _setup_enemy_info():
	enemy_name.text = EnemiesGlobal.active_enemy.enemy_resource.name
	hp_bar.max_value = EnemiesGlobal.active_enemy.enemy_resource.hp
	hp_bar.value = EnemiesGlobal.active_enemy.enemy_resource.hp
	
func _ready() -> void:
	print_debug("level ready")
	_renderDice()
	
	# Init dice value array with appropriate size
	DiceGlobal.dice_value.resize(DiceGlobal.active_dice.size())
	DiceGlobal.dice_value.fill(0)
	
	_renderHeroCard()
	
	_renderEnemy()
	_setup_enemy_info()

func _process(delta: float) -> void:
	var valueText = ""
	for value in DiceGlobal.dice_value:
		valueText += str(value) + " "
	score.text = "[center]%s[/center]" % valueText


func _on_next_level_button_pressed() -> void:
	GameManager.initNewLevel()
	hp_bar.max_value = EnemiesGlobal.active_enemy.enemy_resource.hp
	hp_bar.value = EnemiesGlobal.active_enemy.enemy_resource.hp


func _on_button_pressed() -> void:
	GameManager.attack()
	
	await get_tree().create_timer(1.0).timeout
	
	hp_bar.value = EnemiesGlobal.active_enemy.enemy_resource.hp
