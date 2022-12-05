extends BaseState

@export var acceleration: float = 0.08
@export var gravity_scale: float = 1
@export var state_machine_node: NodePath
@export var idle_node: NodePath
@export var hurt_node: NodePath

@onready var state_machine: Node = get_node(state_machine_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var hurt_state: BaseState = get_node(hurt_node)
@onready var enemy: Enemy = owner


func enter() -> void:
	super()
	enemy.animations.play("Fall")


func physics_process(delta: float) -> BaseState:
	if is_hurt and enemy.staggerable:
		return hurt_state

	if enemy.is_on_floor():
		return idle_state

	enemy.velocity.y += enemy.gravity * delta * gravity_scale
	enemy.move_and_slide()
	return null


func _on_enemy_took_damage() -> void:
	is_hurt = true
