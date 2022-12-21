extends BaseState

@export var animation: String = ""

var death_slowmo := 0.2

@onready var player: Player = owner


func enter() -> void:
	player.collision_layer = 0
	player.collision_mask = 1

	player.current_adrenaline = 0
	player.current_poison = 0

	create_tween().tween_property(player.camera, "zoom", Vector2(1.5, 1.5), 0.75)
	Engine.time_scale = death_slowmo

	player.animations.play(animation)
	await player.animations.animation_finished

	create_tween().tween_property(Engine, "time_scale", 1, 2.0 * death_slowmo)
	SceneManager.reload()


func physics_process(delta: float) -> BaseState:
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.2)
	player.velocity.y += player.gravity * delta * 5
	player.move_and_slide()
	player.set_process(false)
	return null
