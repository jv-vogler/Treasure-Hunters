class_name Enemy
extends Entity

@export var level: int
@export var speed: float = 120.0
@export var jump_velocity: float = -384.0
@export var staggerable: bool = false
@export var invincible: bool = false
@export var loot_table: Array


func _ready() -> void:
	state_machine.init()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


func _process(delta: float) -> void:
	state_machine.process(delta)
