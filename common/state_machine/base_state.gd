class_name BaseState
extends Node

var player: Player


func enter() -> void:
	player.animations.play(name)

func exit() -> void:
	pass

func input(_event: InputEvent) -> BaseState:
	return null

func process(_delta: float) -> BaseState:
	return null

func physics_process(_delta: float) -> BaseState:
	return null
