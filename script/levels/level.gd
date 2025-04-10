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

@onready var current_level_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/LevelContainer/Panel/CurrentLevelLabel

@onready var player_health_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/PlayerInfo/HBoxContainer/Panel/PlayerHealthLabel
@onready var player_shield_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/PlayerInfo/PlayerShieldContainer/Panel/PlayerShieldLabel

@onready var enemy_name: Label = $EnemyInfo/EnemyName
@onready var enemy_hp_value_label: Label = $EnemyInfo/HPValueLabel
@onready var enemy_shield_value_label: Label = $EnemyInfo/ShieldValueLabel

@onready var attack_point_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/AttackDamageCalculatorContainer/Panel/AttackPointLabel
@onready var mult_point_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/AttackDamageCalculatorContainer/Panel2/MultPointLabel
@onready var total_attack_damage: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/TotalDamageContainer/Panel/TotalAttackDamage

@onready var dice_hand_size_label: Label = $DiceHandSize/DiceHandSizeLabel
@onready var hero_hand_size_label: Label = $HeroHandSize/HeroHandSizeLabel

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

func _renderDice() -> void:
	var spacing = 56
	var dice_width = 128
	var total_dice_count = DiceGlobal.active_dice.size()
	var total_width = total_dice_count * dice_width + (total_dice_count - 1) * spacing
	var start_x = (dice_parent.size.x - total_width) / 2 # Centering logic
	print_debug(start_x)
	
	var dice_num = 0
	for dice in DiceGlobal.active_dice:
		var child = dice
		dice.position = Vector2(start_x + dice_num * (spacing + dice_width), dice_parent.size.y / 2)
		child.name = "Dice" + str(dice_num)
		dice_parent.add_child(child)
		dice_num += 1
		
	
func _renderHeroCard() -> void:
	for card in HeroGlobal.active_hero:
		card_factory.create_card(card, hero_card_hand)

func _renderEnemy() -> void:
	var child: Enemy = EnemiesGlobal.active_enemy
	enemy_parent.add_child(child)

func _ready() -> void:
	print_debug("level ready")
	_renderDice()
	
	current_level_label.text = str(GameManager.get_current_level())

	# Init dice value array with appropriate size
	DiceGlobal.dice_value.resize(DiceGlobal.active_dice.size())
	DiceGlobal.dice_value.fill(0)
	
	_renderHeroCard()
	
	_renderEnemy()
	enemy_name.text = EnemiesGlobal.active_enemy.enemy_resource.name
	
	_update_level_state()

#func _process(_delta: float) -> void:
	

func _on_next_level_button_pressed() -> void:
	GameManager.initNewLevel()
	_update_level_state()

func _on_button_pressed() -> void:
	GameManager.end_turn()
	await get_tree().create_timer(1.0).timeout
	_update_level_state()

func _update_level_state():
	enemy_hp_value_label.text = str(EnemiesGlobal.get_enemy_hp())
	enemy_shield_value_label.text = str(EnemiesGlobal.get_enemy_shield())
	
	attack_point_label.text = str(GameManager.attack_point_value)
	mult_point_label.text = str(GameManager.mult_point_value)
	total_attack_damage.text = str(GameManager.attack_point_value * GameManager.mult_point_value)
	
	player_health_label.text = str(PlayersGlobal.hp)
	player_shield_label.text = str(PlayersGlobal.shield)

	current_level_label.text = str(GameManager.get_current_level()) + "/%d"%GameManager.win_level
	
	dice_hand_size_label.text = "%d/%d" %[DiceGlobal.active_dice.size(), DiceGlobal.max_dice_hand_size]
	hero_hand_size_label.text = "%d/%d" %[HeroGlobal.active_hero.size(), HeroGlobal.max_hero_hand_size]
 
