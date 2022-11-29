extends BaseState

@export var idle_node: NodePath
@export var run_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)


func enter():
	super.enter()


func physics_process(delta: float) -> BaseState:
	if player.is_on_floor():
		return idle_state if player.velocity.x != 0 else run_state

	var direction := Input.get_axis("move_left", "move_right")
	player.flip_sprite(direction)

	player.velocity.x = lerp(player.velocity.x, direction * player.SPEED, 0.08)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	return null
