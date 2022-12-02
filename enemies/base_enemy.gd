class_name BaseEnemy
extends CharacterBody2D

@export var staggerable: bool = false
var damage: int = 10


func take_damage(_damage) -> void:
	print("Took " + str(_damage) + " damage.")
