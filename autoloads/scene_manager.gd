extends Node

signal scene_reloaded

var current_scene: PackedScene = null
var previous_scene: PackedScene = null

@onready var _Animation: AnimationPlayer = get_parent().get_node("Game/SceneTransition/Animation")
@onready var _Scene: Control = get_parent().get_node("Game/Scene")


func change_to(target: String, transition := ["Fade Out", "Fade In"]) -> void:
	if current_scene:
		previous_scene = current_scene
	current_scene = load(target)

	if transition[0]:
		_Animation.play(transition[0])
		await _Animation.animation_finished

	if _Scene.get_child_count() > 0:
		_Scene.get_child(0).queue_free()
	_Scene.add_child(current_scene.instantiate())

	if transition[1]:
		_Animation.play(transition[1])
		await _Animation.animation_finished


func reload() -> void:
	if !current_scene:
		printerr("Current scene doesn't exist.")
		return

	_Animation.play("Fade Out")
	await _Animation.animation_finished

	emit_signal("scene_reloaded")

	if _Scene.get_child_count() > 0:
		_Scene.get_child(0).queue_free()
	_Scene.add_child(current_scene.instantiate())

	_Animation.play("Fade In")
	await _Animation.animation_finished
