extends BaseState

@export var idle_node: NodePath
@export var dead_node: NodePath
@export var animation: String = ""
@export_range(150.0, 350.0, 50.0) var knock_height: float = 150.0
@export_range(50.0, 350.0, 50.0) var knock_intensity: float = 50.0

var friction: float = 0.05
var has_knocked: bool = false
var knock_direction: int

@onready var idle_state: Node = get_node(idle_node)
@onready var dead_state: Node = get_node(dead_node)
@onready var return_state: BaseState = null
@onready var player: Player = owner


func enter() -> void:
	has_knocked = false
	player.set_process(false)
	return_state = null
	player.animations.play(animation)
	await player.animations.animation_finished

	return_state = idle_state


func exit() -> void:
	return_state = null
	player.set_process(true)


func physics_process(delta: float) -> BaseState:
	if !has_knocked:
		player.velocity = Vector2(knock_direction * knock_intensity, knock_height * -1)
		has_knocked = true
	player.velocity.x = lerp(player.velocity.x, 0.0, friction)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.current_health == 0:
		return dead_state
	return return_state


func _on_hurtbox_hit_direction(direction) -> void:
	knock_direction = direction
