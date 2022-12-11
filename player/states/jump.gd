extends BaseState

@export var acceleration: float = 0.08
@export var fall_node: NodePath
@export var run_node: NodePath
@export var idle_node: NodePath
@export var hurt_node: NodePath
@export var animation: String = ""

@onready var run_state: BaseState = get_node(run_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var hurt_state: BaseState = get_node(hurt_node)
@onready var player: Player = owner


func enter() -> void:
	super()
	player.animations.play(animation)
	player.velocity.y = player.jump_velocity


func physics_process(delta: float) -> BaseState:
	player.velocity.x = lerp(player.velocity.x, player.direction * player.speed, acceleration)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if is_hurt:
		return hurt_state

	if player.velocity.y > 0:
		return fall_state

	if player.is_on_floor():
		if player.direction != 0:
			return run_state
		return idle_state

	return null


func _on_player_took_damage() -> void:
	is_hurt = true
