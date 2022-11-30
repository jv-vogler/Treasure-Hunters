class_name MoveState
extends BaseState

@export var idle_node: NodePath
@export var run_node: NodePath
@export var jump_node: NodePath
@export var fall_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var jump_state: BaseState = get_node(jump_node)
@onready var fall_state: BaseState = get_node(fall_node)


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("jump"):
		return jump_state

	return null


func physics_process(_delta: float) -> BaseState:
	if !player.is_on_floor():
		return fall_state

	var direction := Input.get_axis("move_left", "move_right")
	player.flip_sprite(direction)

	if direction:
		player.velocity.x = lerp(player.velocity.x, direction * player.SPEED, 0.08)
	else:
		return idle_state

	player.velocity.x = direction * player.SPEED
	player.move_and_slide()

	return null
