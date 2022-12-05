extends BaseState

@export var idle_node: NodePath
@export var hurt_node: NodePath
#@export var attack_node: NodePath
@export_range(0.01, 1, 0.01) var acceleration: float = 0.04

@onready var idle_state: BaseState = get_node(idle_node)
@onready var hurt_state: BaseState = get_node(hurt_node)
#@onready var attack_state: BaseState = get_node(attack_node)
@onready var enemy: Enemy = owner


func enter() -> void:
	super.enter()
	enemy.animations.play("Run")


func physics_process(_delta) -> BaseState:
	if is_hurt and enemy.staggerable:
		return hurt_state

	if !enemy.target:
		return idle_state

	enemy.velocity.x = lerp(enemy.velocity.x, enemy.direction * enemy.speed, acceleration)
	enemy.move_and_slide()
	return null
