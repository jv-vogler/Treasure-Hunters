extends BaseState

@export var friction: float = 0.20
@export var state_machine_node: NodePath
@export var run_node: NodePath
@export var jump_node: NodePath
@export var fall_node: NodePath

@onready var state_machine: Node = get_node(state_machine_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var jump_state: BaseState = get_node(jump_node)
@onready var fall_state: BaseState = get_node(fall_node)


func enter() -> void:
	if state_machine.previous_state == fall_state:
		player.animations.play("Ground")
		await player.animations.animation_finished
	super.enter()


func input(_event: InputEvent) -> BaseState:
	if player.direction:
		return run_state
	elif Input.is_action_just_pressed("jump"):
		return jump_state
	return null


func physics_process(delta: float) -> BaseState:
	player.velocity.x = lerp(player.velocity.x, 0.0, friction)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if !player.is_on_floor():
		return fall_state
	return null
