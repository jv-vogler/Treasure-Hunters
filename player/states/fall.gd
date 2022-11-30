extends BaseState

@export var idle_node: NodePath
@export var run_node: NodePath
@export var jump_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var jump_state: BaseState = get_node(jump_node)

var jump_buffer_timer: float = 0


func enter():
	super.enter()
	jump_buffer_timer = 0


func input(_event: InputEvent) -> BaseState:
	if Input.is_action_pressed("jump"):
		jump_buffer_timer = player.jump_buffer
	return null


func process(delta: float) -> BaseState:
	jump_buffer_timer -= delta
	return null


func physics_process(delta: float) -> BaseState:
	var direction := Input.get_axis("move_left", "move_right")
	player.flip_sprite(direction)

	if player.is_on_floor():
		if jump_buffer_timer > 0: return jump_state
		return run_state if direction else idle_state

	player.velocity.x = lerp(player.velocity.x, direction * player.SPEED, 0.08)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	return null
