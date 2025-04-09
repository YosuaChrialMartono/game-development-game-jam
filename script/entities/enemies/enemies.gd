class_name Enemy
extends Node

@export var enemy_resource: BaseEnemiesResource:
	set(val):
		enemy_resource = val
		needs_update = true
		
@export var needs_update := false

func _process(delta: float) -> void:
	if needs_update: 
		$Sprite2D.texture = enemy_resource.texture
		needs_update = false
