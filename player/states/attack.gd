extends BaseState

@export var state_machine_node: NodePath
@export var idle_node: NodePath
@export var run_node: NodePath
@export var jump_node: NodePath
@export var next_attack_node: NodePath

@onready var state_machine: Node = get_node(state_machine_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var jump_state: BaseState = get_node(jump_node)
@onready var next_attack: BaseState
@onready var player: Player = owner

var attack_buffer: float = 0.3
var acceleration: float = 0.09
var attack_buffer_timer: float = 0
var can_attack: bool
var combo: bool


func enter() -> void:
	can_attack = false
	combo = false
	super.enter()
	attack_buffer_timer = attack_buffer
	await get_tree().create_timer(0.3).timeout
	can_attack = true


func exit() -> void:
	can_attack = false


func _ready() -> void:
	if next_attack_node:
		next_attack = get_node(next_attack_node)


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("attack"):
		if attack_buffer_timer > 0:
			if next_attack: combo = true
	if Input.is_action_just_pressed("jump"):
		return jump_state
	return null


func process(delta: float) -> BaseState:
	attack_buffer_timer -= delta
	return null


func physics_process(delta: float) -> BaseState:
	if can_attack:
		if combo: return next_attack
		return run_state if player.direction else idle_state

	player.velocity.x = lerp(
		player.velocity.x, (player.direction * player.SPEED) / 4, acceleration
		)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	return null
