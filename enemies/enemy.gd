class_name Enemy
extends Entity

@export var level: int = 1
@export_range(60, 600, 10) var speed: float = 80.0
@export_range(1, 9, 1) var stagger_limit: int = 3
@export var loot_table: Array = []
@export var staggerable: bool = true

var floating_text = preload("res://interface/floating_text/floating_text.tscn")
var stagger_count: int = 0:
	set(value):
		stagger_count = clampi(value, 0, stagger_limit)
		if stagger_count == stagger_limit:
			staggerable = false
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
var jump_velocity: float = -384.0
var target: Player = null

@onready var player_detection: Area2D = $PlayerDetection
@onready var attack_range: Area2D = $Sprite/AttackRange
@onready var health_bar: HealthBar = $HealthBar


func _ready() -> void:
	state_machine.init()
	init_health_bar()


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


func take_damage(damage: int) -> void:
	super(damage)
	_update_health_bar()
	_spawn_damage_number(damage)


func init_health_bar() -> void:
	var health_percent: int = Utils.get_percent(current_health, max_health)
	health_bar.hp.value = health_percent
	health_bar.dmg.value = health_percent


func _update_health_bar() -> void:
	var health_percent = Utils.get_percent(current_health, max_health)
	health_bar.update(health_percent)


func _spawn_damage_number(damage: int) -> void:
	var floating_damage: FloatingText = floating_text.instantiate()
	floating_damage.text = str(damage)
	add_child(floating_damage)