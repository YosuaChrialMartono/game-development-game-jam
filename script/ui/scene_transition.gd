extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(target: PackedScene, type: String = 'dissolve') -> void:
	if type == 'dissolve':
		transition_dissolve(target)
	#else:
		#transition_clouds(target)

func transition_dissolve(target: PackedScene) -> void:
	animation_player.play("dissolve")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(target)
	animation_player.play_backwards("dissolve")

#func transition_clouds(target: String) -> void:
	#await $AnimationPlayer.play('clouds_in')
	#get_tree().change_scene(target)
	#$AnimationPlayer.play('clouds_out')
