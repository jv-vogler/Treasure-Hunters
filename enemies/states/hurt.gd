extends BaseState

@export var idle_node: NodePath
@export var chase_node: NodePath
@export var dead_node: NodePath
@export_range(150.0, 350.0, 50.0) var knock_height: float = 150.0
@export_range(50.0, 350.0, 50.0) var knock_intensity: float = 50.0

var friction: float = 0.05
var has_knocked: bool = false
var knock_direction: int

@onready var idle_state: Node = get_node(idle_node)
@onready var chase_state: Node = get_node(chase_node)
@onready var dead_state: Node = get_node(dead_node)
@onready var return_state: BaseState = null
@onready var enemy: Enemy = owner


func enter() -> void:
	enemy.stagger_count += 1
	enemy.animations.play("Hurt")
	await enemy.animations.animation_finished

	return_state = chase_state if enemy.target else idle_state


func exit() -> void:
	has_knocked = false
	return_state = null


func physics_process(delta: float) -> BaseState:
	if !has_knocked:
		enemy.velocity = Vector2(knock_direction * knock_intensity, knock_height * -1)
		has_knocked = true

	if enemy.current_health == 0:
		return dead_state

	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, friction)
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

	return return_state


func _on_hurtbox_hit_direction(direction) -> void:
	knock_direction = direction
