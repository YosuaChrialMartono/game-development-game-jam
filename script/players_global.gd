extends Node

var hp = 10
var shield = 10

func damagePlayer(damage: int):
	print_debug("Damaged Player %s"%damage)
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
