extends Node

const BASE_HP = 10
const BASE_SHIELD = 10

var hp = BASE_HP
var shield = BASE_SHIELD

func damagePlayer(damage: int):
	if damage > shield:
		var tanked_damage = damage - shield
		shield -= damage - tanked_damage
		hp -= tanked_damage
	else:
		shield -= damage

func getPlayerShield() -> int:
	return hp

func getPlayerHP() -> int:
	return hp

func setupNewGame():
	hp = BASE_HP
	shield = BASE_SHIELD
