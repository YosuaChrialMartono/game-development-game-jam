extends Node

enum ENEMY_TYPE {
	BOSS, ENEMIES
}

const ENEMY_CARD_SCENE = preload("res://scenes/characters/Enemies.tscn")
const BOSS_CARD_SCENE = preload("res://scenes/characters/Boss.tscn")

@onready var slime_enemy = load("res://resources/enemies/slime.tres") as BaseEnemiesResource

var active_enemy: Enemy

func add_enemy() -> void:
	var new_enemy = ENEMY_CARD_SCENE.instantiate()
	# Load slime for now
	var enemy_resource = slime_enemy
	
	new_enemy.enemy_resource = slime_enemy
	active_enemy = new_enemy

func damage_enemy(damage: int) -> void:
	active_enemy.enemy_resource.hp -= damage
