class_name Boss
extends Node

@export var boss_resource : BaseBossResource:
	set(val):
		boss_resource = val
		needs_update = true

@export var needs_update := false

func _process(delta: float) -> void:
	if needs_update:
		$Sprite2D.texture = boss_resource.texture
		needs_update = false
		
#func do_ante()
