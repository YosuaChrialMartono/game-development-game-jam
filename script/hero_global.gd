extends Node

var hero_card_dict = {}
var avail_hero_cards = []
var hero_card_info_dir: String = "res://resources/card-info"

var max_hero_hand_size = 5


const HERO_CARD_SCENE = preload("res://scenes/characters/HeroCard.tscn")
@onready var warrior = load("res://resources/heroes/warrior.tres") as BaseHeroResource

var active_hero: Array[String] = []

func _ready() -> void:
	var dir = DirAccess.open(hero_card_info_dir)
	if dir == null:
		push_error("Failed to open directory: %s" % hero_card_info_dir)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !file_name.ends_with(".json"):
			file_name = dir.get_next()
			continue

		var card_name = file_name.get_basename()
		var card_info = _load_card_info(card_name)
		if card_info == null:
			push_error("Failed to load card info for %s" % card_name)
			continue

		hero_card_dict[card_name] = {
			"info": card_info,
		}
		print("Preloaded card data:", hero_card_dict[card_name])
		
		file_name = dir.get_next()

func _load_card_info(card_name: String) -> Dictionary:
	var json_path = hero_card_info_dir + "/" + card_name + ".json"
	if !FileAccess.file_exists(json_path):
		return {}

	var file = FileAccess.open(json_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("Failed to parse JSON: %s" % json_path)
		return {}

	return json.data

func add_hero(hero_type: String) -> void:
	if not hero_type in avail_hero_cards:
		push_error("Hero type %s did not exist" % hero_type)

	active_hero.append(hero_type)

func get_hero_info(hero_type: String):
	if not hero_type in avail_hero_cards:
		push_error("Hero type %s did not exist" % hero_type)

	return hero_card_dict[hero_type]

func setupNewGame():
	active_hero = []
