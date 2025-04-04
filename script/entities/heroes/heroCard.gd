class_name HeroCard
extends Node


enum HERO_ATTACK_RANGE {
	MELEE, RANGED
}

enum DAMAGE_TYPE {
	PHYSICAL, MAGIC
}

@export var card_index: int
@export var hero_resource : BaseHeroResource:
	set(val):
		hero_resource = val
		needs_update = true

@export var needs_update := false

var helper = Helper.new()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if needs_update:
		print_debug(hero_resource)
		$Sprite2D.texture = hero_resource.texture
		needs_update = false

func do_action(action: Action, dice_roll_value: int, elements: Array):
	if action.action_cost > dice_roll_value:
		pass
	if !helper.check_if_arrays_are_the_same(action.element_cost, elements):
		pass
	
	action.execute()
