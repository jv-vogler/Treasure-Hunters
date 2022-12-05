extends BaseState

@export var acceleration: float = 0.08
@export var jump_buffer: float = 0.15
@export var coyote_jump: float = 0.1
@export var gravity_scale: float = 1.5
@export var state_machine_node: NodePath
@export var idle_node: NodePath
@export var run_node: NodePath
@export var jump_node: NodePath
@export var hurt_node: NodePath
@export var attack_node: NodePath
@export var animation: String = ""

var jump_buffer_timer: float = 0
var coyote_jump_timer: float = 0
var can_jump: bool = true

@onready var state_machine: Node = get_node(state_machine_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var jump_state: BaseState = get_node(jump_node)
@onready var hurt_state: BaseState = get_node(hurt_node)
@onready var attack3_state: BaseState = get_node(attack_node)
@onready var player: Player = owner


func enter() -> void:
	super()
	player.animations.play(animation)
	jump_buffer_timer = 0
	coyote_jump_timer = coyote_jump


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer
		if (state_machine.previous_state != jump_state
		and state_machine.previous_state != attack3_state
		and coyote_jump_timer > 0):
				return jump_state
	return null


func process(delta: float) -> BaseState:
	jump_buffer_timer -= delta
	coyote_jump_timer -= delta
	return null


func physics_process(delta: float) -> BaseState:
	if is_hurt:
		return hurt_state

	if player.is_on_floor():
		if jump_buffer_timer > 0:
			return jump_state
		return run_state if player.direction else idle_state

	player.velocity.x = lerp(player.velocity.x, player.direction * player.SPEED, acceleration)
	player.velocity.y += player.gravity * delta * gravity_scale
	player.move_and_slide()

	return null


func _on_player_took_damage() -> void:
	is_hurt = true
