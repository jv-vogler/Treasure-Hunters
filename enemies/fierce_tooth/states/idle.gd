extends BaseState

@export var friction: float = 0.20
@export var state_machine_node: NodePath
@export var fall_node: NodePath

@onready var state_machine: Node = get_node(state_machine_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var enemy: Enemy = owner


func enter() -> void:
	if state_machine.previous_state == fall_state:
		enemy.animations.play("Ground")
		await enemy.animations.animation_finished
	enemy.animations.play("Idle")
