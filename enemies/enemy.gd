class_name Enemy
extends Entity

@export var level: int = 1
@export_range(60, 600, 10) var speed: float = 80.0
@export_range(1, 9, 1) var stagger_limit: int = 3
@export var staggerable: bool = true
@export var loot_table: Array = []

var jump_velocity: float = -384.0
var stagger_count: int = 1
var target: Player = null
var direction: float:
	get:
		if target:
			direction = position.x - target.position.x
			if direction > 0:
				sprite.scale.x = 1
				direction = -1
			elif direction < 0:
				sprite.scale.x = -1
				direction = 1
		else:
			direction = 0
		return direction

@onready var player_detection = $PlayerDetection


func _ready() -> void:
	state_machine.init()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


func _process(delta: float) -> void:
	state_machine.process(delta)


func _on_player_detection_body_entered(body: Node2D) -> void:
	target = body


func _on_player_detection_body_exited(_body: Node2D) -> void:
	target = null
