extends BaseState

@export var friction: float = 0.20
@export var state_machine_node: NodePath
@export var fall_node: NodePath
@export var hurt_node: NodePath

@onready var state_machine: Node = get_node(state_machine_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var hurt_state: BaseState = get_node(hurt_node)
@onready var enemy: Enemy = owner


func enter() -> void:
	super.enter()
	if state_machine.previous_state == fall_state:
		enemy.animations.play("Ground")
		await enemy.animations.animation_finished
	if state_machine.previous_state != hurt_state:
		enemy.animations.play("Idle")


func physics_process(delta: float) -> BaseState:
	if is_hurt and enemy.staggerable:
		return hurt_state

	if !enemy.is_on_floor():
		return fall_state

	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, friction)
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

	return null


func _on_enemy_took_damage() -> void:
	is_hurt = true
