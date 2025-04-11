class_name Enemy
extends Node

@onready var sprite = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cloth_sfx: AudioStreamPlayer2D = $ClothSFX

@export var enemy_resource: BaseEnemiesResource:
	set(val):
		enemy_resource = val
		needs_update = true
		
@export var needs_update := false

func _process(_delta: float) -> void:
	if needs_update:
		sprite.texture = enemy_resource.texture
		needs_update = false
		
func destroy_card() -> Signal:
	cloth_sfx.play()
	animation_player.play("card_dissolve")
	return animation_player.animation_finished

func card_enter() -> Signal:
	cloth_sfx.play()
	animation_player.play_backwards("card_dissolve")
	return animation_player.animation_finished
