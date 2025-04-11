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

@onready var enemy_name: Label = $EnemyInfo/MarginContainer/VBoxContainer/EnemyName
@onready var enemy_hp_value_label: Label = $EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer/Panel/HPValueLabel
@onready var enemy_shield_value_label: Label = $EnemyInfo/MarginContainer/VBoxContainer/HBoxContainer2/Panel/ShieldValueLabel

@onready var total_attack_damage: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/TotalDamageContainer/Panel/TotalAttackDamage
@onready var attack_point_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/TotalDamageContainer/AttackDamageCalculatorContainer/Panel/AttackPointLabel
@onready var mult_point_label: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/TotalDamageContainer/AttackDamageCalculatorContainer/Panel2/MultPointLabel

@onready var dice_hand_size_label: Label = $DiceHandSize/DiceHandSizeLabel
@onready var hero_hand_size_label: Label = $HeroHandSize/HeroHandSizeLabel

@onready var lose_scene: Control = $LoseScene
@onready var win_scene: Control = $WinScene
@onready var options_scene: Control = $OptionsScene

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

func _renderDice() -> void:
	var spacing := 56.0
	var base_dice_width := 128.0
	var base_dice_height := 128.0
	var total_dice_count := DiceGlobal.active_dice.size()

	# Calculate max columns based on available width and scaling
	var available_width: int = int(dice_parent.size.x)
	var available_height: int = int(dice_parent.size.y)
	
	# Calculate margin
	var margin: int = 24
	available_height -= margin * 2
	available_width -= margin * 2

	# Estimate the number of columns we want to fit (based on max_hand_size and available width)
	var est_columns = sqrt(total_dice_count)
	est_columns = ceil(est_columns)

	# Recalculate how many columns we can fit with scaled values
	var max_columns: int = max(1, est_columns) # At least one column

	# var num_rows: int = ceil(float(total_dice_count) / max_columns)
	var num_rows = ceil(float(total_dice_count) / max_columns)

	var required_width: int = est_columns * base_dice_width + (est_columns - 1) * spacing
	var require_height: int = num_rows * base_dice_height + (num_rows - 1) * spacing

	var scale_factor: float = 1.0
	if required_width > available_width:
		scale_factor = float(available_width) / required_width
	if require_height > available_height:
		scale_factor = float(available_height) / require_height

	print_debug(scale_factor)

	var scaled_dice_width := base_dice_width * scale_factor
	var scaled_dice_height := base_dice_height * scale_factor
	var scaled_spacing := spacing * scale_factor
	print_debug(scaled_dice_width)
	print_debug(scaled_dice_height)
	print_debug(scaled_spacing)


	# Compute total layout height to center vertically
	var total_height: float = num_rows * scaled_dice_height + (num_rows - 1) * scaled_spacing
	var start_y: float = (available_height - total_height) / 2

	# Optional: clear previous dice
	for child in dice_parent.get_children():
		child.queue_free()

	for i in range(total_dice_count):
		var row := int(i / float(max_columns))
		var col := i % max_columns
		var dice = DiceGlobal.active_dice[i]

		# Compute row start X to center each row individually
		var current_row_count: int = min(max_columns, total_dice_count - row * max_columns)
		var row_width := current_row_count * scaled_dice_width + (current_row_count - 1) * scaled_spacing
		var start_x := (available_width - row_width) / 2

		dice.position = Vector2(
			margin + start_x + col * (scaled_dice_width + scaled_spacing),
			margin + start_y + row * (scaled_dice_height + scaled_spacing)
		)
		dice.scale = Vector2(scale_factor, scale_factor)
		dice.name = "Dice" + str(i)
		dice_parent.add_child(dice)

		
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
	
func _on_options_button_pressed() -> void:
	options_scene.visible=true

func _update_level_state():
	enemy_hp_value_label.text = str(EnemiesGlobal.get_enemy_hp())
	enemy_shield_value_label.text = str(EnemiesGlobal.get_enemy_shield())
	
	attack_point_label.text = str(GameManager.attack_point_value)
	mult_point_label.text = str(GameManager.mult_point_value)
	total_attack_damage.text = str(GameManager.attack_point_value * GameManager.mult_point_value)
	
	player_health_label.text = str(PlayersGlobal.hp)
	player_shield_label.text = str(PlayersGlobal.shield)

	var current_level_text = str(GameManager.get_current_level())
	if not GameManager.is_endless_mode:
		current_level_text += "/%d"%GameManager.win_level
	current_level_label.text = current_level_text
	
	dice_hand_size_label.text = "%d/%d" % [DiceGlobal.active_dice.size(), DiceGlobal.max_dice_hand_size]
	hero_hand_size_label.text = "%d/%d" % [HeroGlobal.active_hero.size(), HeroGlobal.max_hero_hand_size]

	if (GameManager.get_current_level() == GameManager.win_level) && (not GameManager.is_endless_mode):
		win_scene.visible = true
	
	if PlayersGlobal.hp <= 0:
		lose_scene.visible = true
