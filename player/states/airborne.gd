extends BaseState

@export var fall_node: NodePath

@onready var fall_state: BaseState = get_node(fall_node)


func enter():
	super.enter()
	player.velocity.y = player.JUMP_VELOCITY


func physics_process(delta: float) -> BaseState:
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.velocity.y > 0:
		return fall_state

	return null
