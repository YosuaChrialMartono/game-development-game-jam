extends Node

@onready var score = $MarginContainer/Panel/MarginContainer/VBoxContainer/Score
@onready var dice_parent: Panel = $DiceParent
@onready var hero_card_parent: Panel = $HeroCardParent
@onready var enemy_parent: Control = $EnemyParent

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 10
@export var x_sep := 56
@export var y_min := 50
@export var y_max := -50

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

func renderDice() -> void:
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
		
func renderHeroCard() -> void:
	for i:int in range(HeroGlobal.active_hero.size()):
		var child: HeroCard = HeroGlobal.active_hero[i]
		#child.card_index = i
		hero_card_parent.add_child(child)
		
func renderEnemy() -> void:
	EnemiesGlobal.add_enemy()
	var child: Enemy = EnemiesGlobal.active_enemy
	enemy_parent.add_child(child)
		
func _update_cards() -> void:
	var cards = HeroGlobal.active_hero.size()
	var all_cards_size:int = HeroCard.SIZE.x * cards + x_sep * (cards -1)
	var final_x_sep := x_sep
	
	if all_cards_size > hero_card_parent.size.x:
		final_x_sep = (hero_card_parent.size.x - HeroCard.SIZE.x * cards) / (cards -1)
		all_cards_size = hero_card_parent.size.x
		print_debug(all_cards_size)
		print_debug(hero_card_parent.size.x)
		
	var offset := (hero_card_parent.size.x - all_cards_size) / 2
	print_debug(final_x_sep)
	
	for i in cards:
		var card := hero_card_parent.get_child(i)
		#var y_multiplier := hand_curve.sample(1.0 / (cards-1) * i)
		#var rot_multiplier := rotation_curve.sample(1.0 / (cards-1) * i) 
		
		#if cards == 1:
			#y_multiplier = 0.0
			#rot_multiplier = 0.0
		
		var final_x: float = offset + HeroCard.SIZE.x * i + final_x_sep * i
		#var final_y: float = y_min + y_max * y_multiplier
		var final_y: float = y_min 
		
		card.position = Vector2(final_x, final_y)
		#card.rotation_degrees = max_rotation_degrees * rot_multiplier

#func _input(event):
	## Reset dice values
	#if Input.is_action_just_pressed("ui_accept"):
		#

func _ready() -> void:
	print_debug("level ready")
	renderDice()
	
	# Init dice value array with appropriate size
	DiceGlobal.dice_value.resize(DiceGlobal.active_dice.size())
	DiceGlobal.dice_value.fill(0)
	
	renderHeroCard()
	_update_cards()
	
	renderEnemy()

func _process(delta: float) -> void:
	var valueText = ""
	for value in DiceGlobal.dice_value:
		valueText += str(value) + " "
	score.text = "[center]%s[/center]" % valueText

#func _notification(what):
	#if what == NOTIFICATION_RESIZED:
		#renderDice()  # Recalculate positions on resize


func _on_damage_button_pressed() -> void:
	EnemiesGlobal.damage_enemy(1)
