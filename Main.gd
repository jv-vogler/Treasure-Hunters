class_name Game
extends Node2D

var test_scene = preload("res://levels/test_level.tscn")

@onready var Scene = $Scene


func _ready() -> void:
#	Scene.add_child(test_scene.instantiate())
	change_scene("res://levels/test_level.tscn", "", "Dissolve")


func change_scene(target: String, in_transition := "", out_transition := "") -> void:
	if in_transition:
		$SceneTransition/Animation.play(in_transition)
		await $SceneTransition/Animation.animation_finished

	if Scene.get_child_count() > 0:
		get_tree().reload_current_scene()
		Scene.get_child(0).queue_free()
	Scene.add_child(load(target).instantiate())

	if out_transition:
		$SceneTransition/Animation.play_backwards("Dissolve")
		await $SceneTransition/Animation.animation_finished


func _on_button_pressed() -> void:
	change_scene("res://levels/test_level.tscn", "Dissolve", "Dissolve")
