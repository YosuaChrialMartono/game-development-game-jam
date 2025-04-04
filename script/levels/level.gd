extends Node

@onready var score = $MarginContainer/Panel/MarginContainer/VBoxContainer/Score
@onready var dice_parent: Panel = $DiceParent

const DICE_SCENE = preload("res://scenes/characters/Dice.tscn")

func renderDice() -> void:
	var dice_count = DiceGlobal.active_dice.size()
	var spacing = 150
	
	# Calculate starting x position so dice are centered
	var total_width = (dice_count * Dice.SIZE.x) + (dice_count - 1) * spacing
	#var start_x = (x - total_width) / 2  # Centering logic
	
	for i:int in range(DiceGlobal.active_dice.size()):
		var child = DICE_SCENE.instantiate()
		child.position = Vector2( 64 + i * spacing, dice_parent.size.y / 2)  # 70% down the screen
		child.name = "Dice" + str(i)
		child.type = DiceGlobal.active_dice[i]
		child.dice_index = i
		dice_parent.add_child(child)

func _input(event):
	# Reset dice values
	if Input.is_action_just_pressed("ui_accept"):
		DiceGlobal.reset_dice_value()

func _ready() -> void:
	print_debug("level ready")
	renderDice()
	
	# Init dice value array with appropriate size
	for i:int in range(DiceGlobal.active_dice.size()):
		DiceGlobal.dice_value.append(0)

func _process(delta: float) -> void:
	#var totalValue = 0
	#for value in DiceGlobal.DiceValue:
		#if value is int:
			#totalValue += value
	#score.text = str(totalValue)
	#print_debug(DiceGlobal.DiceValue)
	var valueText = ""
	for value in DiceGlobal.dice_value:
		valueText += str(value) + " "
	score.text = "[center]%s[/center]" % valueText

#func _notification(what):
	#if what == NOTIFICATION_RESIZED:
		#renderDice()  # Recalculate positions on resize
