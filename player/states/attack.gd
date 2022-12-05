extends BaseState

@export var state_machine_node: NodePath
@export var idle_node: NodePath
@export var run_node: NodePath
@export var hurt_node: NodePath
@export var fall_node: NodePath
@export var next_attack_node: NodePath
@export var animation: String = ""
@export var can_attack: bool = false
@export_range(0.0, 500.0, 50.0) var lunge_distance: float = 200.0

var acceleration: float = 0.09
var attack_buffer: float = 0.3
var attack_buffer_timer: float = 0
var combo: bool = false

@onready var state_machine: Node = get_node(state_machine_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var hurt_state: BaseState = get_node(hurt_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var next_attack: BaseState
@onready var player: Player = owner


func _ready() -> void:
	if next_attack_node:
		next_attack = get_node(next_attack_node)


func enter() -> void:
	super()
	if !is_hurt:
		player.animations.play(animation)
		attack_buffer_timer = attack_buffer
		if animation == "Attack2":
			player.velocity += Vector2(lunge_distance * player.sprite.scale.x, -50.0)
		if animation == "Attack3":
			player.velocity += Vector2(lunge_distance * player.sprite.scale.x, -100.0)
#		await player.animations.animation_finished
#		can_attack = true


func exit() -> void:
	can_attack = false
	combo = false


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("attack"):
		if attack_buffer_timer > 0:
			if next_attack:
				combo = true
	return null


func process(delta: float) -> BaseState:
	attack_buffer_timer -= delta
	return null


func physics_process(delta: float) -> BaseState:
	if is_hurt:
		return hurt_state

	if can_attack:
		if !player.is_on_floor():
			return fall_state

		if combo:
			return next_attack

		return run_state if player.direction else idle_state

	player.velocity.x = lerp(
		player.velocity.x, (player.direction * player.SPEED) / 4, acceleration
		)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	return null


func _on_player_took_damage() -> void:
	is_hurt = true
