extends Node

var current_scene: PackedScene = null
var previous_scene: PackedScene =-null

@onready var _Animation: AnimationPlayer = get_parent().get_node("Game/SceneTransition/Animation")
@onready var _Scene: Control = get_parent().get_node("Game/Scene")


func change_to(target: PackedScene, transition_out := "", transition_in := "") -> void:
	if current_scene:
		previous_scene = current_scene
	current_scene = target

	if transition_out:
		_Animation.play(transition_out)
		await _Animation.animation_finished

	if _Scene.get_child_count() > 0:
		_Scene.get_child(0).queue_free()
	_Scene.add_child(target.instantiate())

	if transition_in:
		_Animation.play(transition_in)
		await _Animation.animation_finished
