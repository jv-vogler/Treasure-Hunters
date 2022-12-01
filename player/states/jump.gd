extends BaseState

@export var acceleration: float = 0.08
@export var fall_node: NodePath
@export var run_node: NodePath
@export var idle_node: NodePath

@onready var run_state: BaseState = get_node(run_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var idle_state: BaseState = get_node(idle_node)


func enter() -> void:
	super.enter()
	player.velocity.y = player.JUMP_VELOCITY


func physics_process(delta: float) -> BaseState:
	var direction := Input.get_axis("move_left", "move_right")
	player.flip_sprite(direction)

	player.velocity.x = lerp(player.velocity.x, direction * player.SPEED, acceleration)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.velocity.y > 0:
		return fall_state

	if player.is_on_floor():
		if direction != 0:
			return run_state
		return idle_state
	return null
