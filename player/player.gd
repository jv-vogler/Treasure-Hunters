class_name Player
extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -384.0

@export var acceleration: float = 0.2
@export var friction: float = 0.1

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float:
	get:
		direction = Input.get_axis("move_left", "move_right")
		if direction > 0: sprite.scale.x = 1
		if direction < 0: sprite.scale.x = -1
		return direction

@onready var states = $States
@onready var animations = $Animations
@onready var sprite = $Sprite


func _ready() -> void:
	states.init(self)


func _unhandled_input(event: InputEvent) -> void:
	states.input(event)


func _physics_process(delta: float) -> void:
	states.physics_process(delta)


func _process(delta: float) -> void:
	states.process(delta)
