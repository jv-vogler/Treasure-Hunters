extends BaseState

@export var acceleration: float = 0.08
@export var jump_buffer: float = 0.15
@export var coyote_jump: float = 0.1
@export var gravity_scale: float = 1.5
@export var state_machine_node: NodePath
@export var idle_node: NodePath
@export var run_node: NodePath
@export var jump_node: NodePath

@onready var state_machine: Node = get_node(state_machine_node)
@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var jump_state: BaseState = get_node(jump_node)
@onready var player: Player = owner

var jump_buffer_timer: float = 0
var coyote_jump_timer: float = 0
var can_jump: bool = true


func enter() -> void:
	super.enter()
	jump_buffer_timer = 0
	coyote_jump_timer = coyote_jump


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_pressed("jump"):
		jump_buffer_timer = jump_buffer
		if state_machine.previous_state != jump_state and coyote_jump_timer > 0:
				return jump_state
	return null


func process(delta: float) -> BaseState:
	jump_buffer_timer -= delta
	coyote_jump_timer -= delta
	return null


func physics_process(delta: float) -> BaseState:
	if player.is_on_floor():
		if jump_buffer_timer > 0: return jump_state
		return run_state if player.direction else idle_state

	player.velocity.x = lerp(player.velocity.x, player.direction * player.SPEED, acceleration)
	player.velocity.y += player.gravity * delta * gravity_scale
	player.move_and_slide()

	return null
