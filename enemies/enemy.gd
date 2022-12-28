class_name Enemy
extends Entity

enum Status { POISONED = 1 }

@export var level: int = 1
@export_range(60, 600, 10) var speed: float = 80.0
@export var staggerable: bool = true
@export_range(0, 9, 1) var stagger_limit: int = 3
@export var loot_table: Array = []

@export var max_health: int = 100
@export var strength: float = 20.0

var current_health: int:
	set(value):
		current_health = clamp(value, 0, max_health)
		emit_signal("health_changed", current_health, max_health)
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
var stagger_count: int = 0:
	set(value):
		stagger_count = clampi(value, 0, stagger_limit)
		if stagger_count >= stagger_limit:
			staggerable = false
		else:
			staggerable = true
var target: Player = null
var status: int
var poison_counter: int = 0
var _poison_damage_scale: float = 0.02
var _floating_text = preload("res://interface/floating_text/floating_text.tscn")

@onready var player_detection: Area2D = $PlayerDetection
@onready var attack_range: Area2D = $Sprite/AttackRange
@onready var health_bar: HealthBar = $HealthBar
@onready var poison_timer: Timer = $PoisonTimer
@onready var attack_timer: Timer = $AttackTimer


func _ready() -> void:
	state_machine.init()
	_init_health_bar()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


func _process(delta: float) -> void:
	state_machine.process(delta)


func take_damage(damage: int) -> void:
	emit_signal("took_damage")
	current_health -= damage
	_update_health_bar()
	_spawn_damage_number(damage)


func _init_health_bar() -> void:
	current_health = max_health
	var health_percent: int = Utils.get_percent(current_health, max_health)
	health_bar.hp.value = health_percent
	health_bar.dmg.value = health_percent


func _update_health_bar() -> void:
	var new_health_percent = Utils.get_percent(current_health, max_health)
	health_bar.update(new_health_percent)


func _spawn_damage_number(damage: int, type: String = "regular") -> void:
	var floating_damage: FloatingText = _floating_text.instantiate()
	floating_damage.text = str(damage)
	floating_damage.type = type
	add_child(floating_damage)


func _on_player_detection_body_entered(body: Node2D) -> void:
	target = body


func _on_player_detection_body_exited(_body: Node2D) -> void:
	target = null


func _on_got_poisoned() -> void:
	sprite.modulate = Color("#6ffc90")
	poison_timer.start()


func _on_poison_timer_timeout() -> void:
	if current_health == 0 or poison_counter >=  2:
		poison_timer.stop()
		status -= Status.POISONED
		sprite.modulate = Color("#ffffff")
		poison_counter = 0
		_poison_damage_scale = 0.02
		return

	var damage: int = int(max_health * _poison_damage_scale)
	current_health -= damage
	_update_health_bar()
	_spawn_damage_number(damage, "poison")
	_poison_damage_scale *= 2
	poison_counter += 1
	poison_timer.start()


func _on_died() -> void:
	queue_free()
