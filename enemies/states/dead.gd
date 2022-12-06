extends BaseState

@export_range(150.0, 350.0, 50.0) var knock_height: float = 150.0

@onready var enemy: Enemy = owner


func enter() -> void:
	enemy.animations.play("Death")
	enemy.collision_layer = 0
	enemy.collision_mask = 1	# If 0, can make enemy drop (check if on a plank -> fall on water)
	enemy.velocity = Vector2(0, knock_height * -1)
	enemy.set_process(false)


func physics_process(delta: float) -> BaseState:
	enemy.velocity.x = lerp(enemy.velocity.x, 0.0, 0.2)
	enemy.velocity.y += enemy.gravity * delta * 0.9
	enemy.move_and_slide()
	return null
