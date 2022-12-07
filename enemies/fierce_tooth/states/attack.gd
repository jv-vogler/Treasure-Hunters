extends BaseState

@export var idle_node: NodePath
@export var hurt_node: NodePath
@export var dead_node: NodePath
@export_range(0, 550.0, 50.0) var lunge_distance: float = 350.0

var attack_finished: bool = false
var attack_direction: float

@onready var idle_state: BaseState = get_node(idle_node)
@onready var hurt_state: BaseState = get_node(hurt_node)
@onready var dead_state: BaseState = get_node(dead_node)
@onready var enemy: Enemy = owner


func enter() -> void:
	super()
	attack_direction = enemy.direction
	enemy.animations.play("Anticipation")
	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, 0.9)
	await enemy.animations.animation_finished
	if !is_hurt and enemy.current_health > 0:
		_attack()


func exit() -> void:
	attack_finished = false


func physics_process(delta: float) -> BaseState:
	if enemy.current_health == 0:
		return dead_state

	if is_hurt and enemy.staggerable:
		return hurt_state

	if attack_finished:
		return idle_state

	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, 0.05)
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

	return null


func _attack() -> void:
	enemy.animations.play("Attack")
	enemy.velocity = Vector2(lunge_distance * attack_direction, -150.0)
	await enemy.animations.animation_finished
	attack_finished = true
	enemy.staggerable = true
	enemy.stagger_count = 0


func _on_took_damage() -> void:
	is_hurt = true if enemy.staggerable else false
