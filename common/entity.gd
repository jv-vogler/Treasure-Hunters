class_name Entity
extends CharacterBody2D

@export var strength: int = 20
@export var max_health: int = 100

var current_health: int = 100:
	set(value):
		current_health = clamp(value, 0, max_health)
var acceleration: float = 0.2
var friction: float = 0.1
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite
@onready var animations = $Animations
@onready var state_machine = $StateMachine


func take_damage(damage) -> void:
	print("{0} received {1} damage.".format([name, damage]))
	current_health -= damage
	if current_health == 0:
		die()


func die() -> void:
	print("{0} died.".format([name]))
	queue_free()
