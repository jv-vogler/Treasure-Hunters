class_name Entity
extends CharacterBody2D

signal took_damage

@export var strength: int = 10
@export var max_health: int = 100

var acceleration: float = 0.2
var friction: float = 0.1
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_health: int:
	set(value):	current_health = clamp(value, 0, max_health)

@onready var sprite: Sprite2D = $Sprite
@onready var animations: AnimationPlayer = $Animations
@onready var state_machine: StateMachine = $StateMachine


func _init() -> void:
	current_health = max_health


func take_damage(damage) -> void:
	print("%s received %s damage." % [name, damage])
	emit_signal("took_damage")
	current_health -= damage
	if current_health == 0:
		die()


func die() -> void:
	print("%s died." % name)
#	queue_free()
