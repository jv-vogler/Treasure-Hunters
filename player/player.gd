class_name Player
extends CharacterBody2D


const SPEED = 140.0
const JUMP_VELOCITY = -350.0

@export var acceleration: float = 0.08
@export var friction: float = 0.20

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		$Sprite.scale.x = 1 if (direction > 0) else -1
		velocity.x = lerp(velocity.x, direction * SPEED, 0.08)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.20)

	move_and_slide()
