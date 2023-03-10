extends BaseState

@export var idle_node: NodePath
@export var hurt_node: NodePath
@export var dead_node: NodePath
@export var attack_node: NodePath
@export_range(0.01, 1, 0.01) var acceleration: float = 0.03

var is_in_range: bool = false
var should_attack: bool = false

@onready var idle_state: BaseState = get_node(idle_node)
@onready var hurt_state: BaseState = get_node(hurt_node)
@onready var dead_state: BaseState = get_node(dead_node)
@onready var attack_state: BaseState = get_node(attack_node)
@onready var enemy: Enemy = owner


func enter() -> void:
	super()
	enemy.animations.play("Run")
	enemy.attack_range.get_child(0).disabled = false


func exit() -> void:
	is_in_range = false
	should_attack = false
	enemy.attack_range.get_child(0).disabled = true


func physics_process(_delta) -> BaseState:
	if enemy.current_health == 0:
		return dead_state

	if is_hurt and enemy.staggerable:
		return hurt_state

	if !enemy.target and enemy.current_health > 0:
		return idle_state

	if is_in_range and should_attack:
		return attack_state

	enemy.velocity.x = lerp(enemy.velocity.x, enemy.direction * enemy.speed, acceleration)
	enemy.move_and_slide()
	return null


func _on_attack_range_body_entered(_body: Node2D) -> void:
	if !should_attack:
		var random_delay = randf_range(0.1, 0.5)
		enemy.attack_timer.start(random_delay)
	is_in_range = true


func _on_took_damage() -> void:
	is_hurt = true


func _on_attack_timer_timeout() -> void:
	should_attack = true
