class_name Game
extends Node2D

var test_scene = preload("res://levels/test_level.tscn")

@onready var _scene = $Scene


func _ready() -> void:
	_scene.add_child(test_scene.instantiate())


func change_scene(target: String) -> void:
	$SceneTransition/Animation.play("Dissolve")
	await $SceneTransition/Animation.animation_finished
	get_tree().change_scene_to_file(target)
	$SceneTransition/Animation.play_backward("Dissolve")
