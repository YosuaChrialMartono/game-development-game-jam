extends Node

enum ENEMY_TYPE {
	BOSS, ENEMIES
}

const ENEMY_CARD_SCENE = preload("res://scenes/characters/Enemies.tscn")
const BOSS_CARD_SCENE = preload("res://scenes/characters/Boss.tscn")

@onready var slime_enemy = load("res://resources/enemies/slime.tres") as BaseEnemiesResource

@onready var active_enemy: Enemy
@onready var _enemy_hp = 0
@onready var _enemy_shield = 0

func set_enemy() -> void:
	var new_enemy = ENEMY_CARD_SCENE.instantiate()
	# Load slime for now
	var enemy_resource = slime_enemy
	
	_enemy_hp = enemy_resource.hp
	_enemy_shield = enemy_resource.shield
	
	new_enemy.enemy_resource = slime_enemy
	active_enemy = new_enemy
	print_debug(active_enemy.enemy_resource.hp)

func damage_enemy(damage: int) -> void:
	if damage > get_enemy_shield():
		var tanked_damage = damage - _enemy_shield
		_enemy_shield -= damage - tanked_damage
		_enemy_hp -= tanked_damage
	else:
		_enemy_shield -= damage

func get_enemy_hp() -> int:
	return _enemy_hp

func set_enemy_hp(newHp: int) -> void:
	_enemy_hp = newHp

func get_enemy_shield() -> int:
	return _enemy_shield

func set_enemy_shield(newShield: int) -> void:
	_enemy_shield = newShield
