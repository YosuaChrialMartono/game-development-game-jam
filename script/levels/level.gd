extends Node

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

@onready var attack_point_label: Label = $"MarginContainer/Panel/MarginContainer/VBoxContainer/Attack Damage/Panel/AttackPointLabel"
@onready var mult_point_label: Label = $"MarginContainer/Panel/MarginContainer/VBoxContainer/Attack Damage/Panel2/MultPointLabel"
@onready var total_attack_damage: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer/Panel/TotalAttackDamage

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

func _renderDice() -> void:
	var spacing = 150
	
	#var start_x = (x - total_width) / 2  # Centering logic
	
	var dice_num = 0
	for dice in DiceGlobal.active_dice:
		var child = dice
		dice.position = Vector2(128 + dice_num * spacing, dice_parent.size.y / 2) # 70% down the screen
		child.name = "Dice" + str(dice_num)
		dice_parent.add_child(child)
		dice_num += 1
		
	
func _renderHeroCard() -> void:
	for card in HeroGlobal.active_hero:
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

#func _process(_delta: float) -> void:
	


func _on_next_level_button_pressed() -> void:
	GameManager.initNewLevel()
	hp_bar.max_value = EnemiesGlobal.active_enemy.enemy_resource.hp
	hp_bar.value = EnemiesGlobal.active_enemy.enemy_resource.hp


func _on_button_pressed() -> void:
	GameManager.attack()
	
	await get_tree().create_timer(1.0).timeout
	
	hp_bar.value = EnemiesGlobal.active_enemy.enemy_resource.hp
	
	attack_point_label.text = str(GameManager.attack_point_value)
	mult_point_label.text = str(GameManager.mult_point_value)
	total_attack_damage.text = str(GameManager.attack_point_value * GameManager.mult_point_value)
