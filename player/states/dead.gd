extends BaseState

@export var animation: String = ""

@onready var player: Player = owner


func enter() -> void:
	player.animations.play(animation)
	player.collision_layer = 0
	await player.animations.animation_finished


func physics_process(delta: float) -> BaseState:
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.2)
	player.velocity.y += player.gravity * delta * 5
	player.move_and_slide()
	player.set_process(false)
	return null
