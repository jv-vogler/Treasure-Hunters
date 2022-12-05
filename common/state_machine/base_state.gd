class_name BaseState
extends Node

var is_hurt: bool = false


func enter() -> void:
	is_hurt = false

func exit() -> void:
	pass

func input(_event: InputEvent) -> BaseState:
	return null

func process(_delta: float) -> BaseState:
	return null

func physics_process(_delta: float) -> BaseState:
	return null
