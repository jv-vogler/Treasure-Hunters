class_name Player
extends Entity

const SPEED = 120.0
const JUMP_VELOCITY = -384.0

var direction: float:
	get:
		direction = Input.get_axis("move_left", "move_right")
		if direction > 0: sprite.scale.x = 1
		if direction < 0: sprite.scale.x = -1
		return direction


func _ready() -> void:
	state_machine.init()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


func _process(delta: float) -> void:
	state_machine.process(delta)
