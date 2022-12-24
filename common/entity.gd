class_name Entity
extends CharacterBody2D

signal took_damage
signal health_changed

var acceleration: float = 0.2
var friction: float = 0.1
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: Sprite2D = $Sprite
@onready var animations: AnimationPlayer = $Animations
@onready var state_machine: StateMachine = $StateMachine
