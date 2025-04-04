extends Node

enum HERO_TYPE {
	WARRIOR, ARCHER, MAGE, SHIELD, PRIEST
}

const HERO_CARD_SCENE = preload("res://scenes/characters/HeroCard.tscn")
@onready var warrior = load("res://resources/heroes/warrior.tres") as BaseHeroResource

var active_hero: Array[HeroCard] = []

func _ready() -> void:
	print_debug("warrior resource loaded:", warrior)
	print_debug(HERO_TYPE.WARRIOR)
	print_debug(HERO_TYPE.find_key(HERO_TYPE.WARRIOR))


func add_hero(hero_type: HERO_TYPE) -> void:
	var new_hero = HERO_CARD_SCENE.instantiate()
	var hero_resource
	
	if hero_type == HERO_TYPE.WARRIOR:
		hero_resource = warrior
	
	
	new_hero.hero_resource = hero_resource
	active_hero.append(new_hero)
