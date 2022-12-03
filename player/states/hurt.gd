extends BaseState

@export var idle_node: NodePath
@export var dead_node: NodePath
@export var animation: String = ""

@onready var idle_state: Node = get_node(idle_node)
@onready var dead_state: Node = get_node(dead_node)
@onready var return_state: BaseState = null
@onready var player: Player = owner


func enter() -> void:
	return_state = null
	player.animations.play(animation)
	await player.animations.animation_finished

	return_state = idle_state


func exit() -> void:
	return_state = null


func physics_process(_delta: float) -> BaseState:
	if player.current_health == 0:
		return dead_state
	return return_state
