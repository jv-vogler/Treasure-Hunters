extends MoveState

@export var state_machine_node: NodePath

@onready var state_machine: Node = get_node(state_machine_node)


func enter() -> void:
	if state_machine.previous_state == fall_state:
		player.animations.play("Ground")
		await player.animations.animation_finished
	super.enter()


func input(event: InputEvent) -> BaseState:
	var new_state = super.input(event)
	if new_state:
		return new_state

	return null
