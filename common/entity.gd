class_name Entity
extends CharacterBody2D

@export var acceleration: float = 0.2
@export var friction: float = 0.1
@export var health: int = 10
@export var damage: int = 1

@onready var sprite = $Sprite
@onready var animations = $Animations
@onready var state_machine = $StateMachine

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func take_damage(damage) -> void:
	print(str(name) + " received " + str(damage) + " damage.")
