class_name Entity
extends CharacterBody2D

signal took_damage
signal health_changed

@export var max_health: int = 100
@export var strength: float = 20.0

var current_health: int:
	set(value):
		current_health = clamp(value, 0, max_health)
		emit_signal("health_changed", current_health, max_health)
var acceleration: float = 0.2
var friction: float = 0.1
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: Sprite2D = $Sprite
@onready var animations: AnimationPlayer = $Animations
@onready var state_machine: StateMachine = $StateMachine


func take_damage(damage) -> void:
	print("%s received %s damage." % [name, damage])
	emit_signal("took_damage")
	current_health -= damage
	if current_health == 0:
		die()


func die() -> void:
	print("%s died." % name)
#	queue_free()
