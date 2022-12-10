class_name Player
extends Entity

enum Buff { POISON = 1, ADRENALINE = 2, ALL = 3 }

var direction: float:
	get:
		direction = Input.get_axis("move_left", "move_right")
		if direction > 0: sprite.scale.x = 1
		if direction < 0: sprite.scale.x = -1
		return direction
var stats: Stats = preload("res://resources/stats.tres")
var max_poison: int
var max_adrenaline: int
var current_poison: float = 0:
	set(value):	current_poison = clamp(value, 0, max_poison)
var current_adrenaline: float = 0:
	set(value):	current_adrenaline = clamp(value, 0, max_adrenaline)
var buffs: int
var speed: float
var jump_velocity: float


func _ready() -> void:
	state_machine.init()
	_init_stats()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)

	# TODO - put buff triggers in states/items
	if Input.is_action_just_pressed("activate_adrenaline") and current_adrenaline == max_adrenaline:
		activate_adrenaline()

	if Input.is_action_just_pressed("activate_poison"):
		if buffs & Buff.POISON:
			return
		activate_poison()


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	_handle_buffs()


func _process(delta: float) -> void:
	state_machine.process(delta)


func succesful_hit() -> void:
	current_adrenaline += 1
	current_poison -= 2


func activate_adrenaline() -> void:
	buffs += Buff.ADRENALINE
	animations.playback_speed = 1.5
	strength *= 1.5
	speed *= 1.2


func activate_poison() -> void:
	buffs += Buff.POISON
	current_poison = max_poison


func _init_stats() -> void:
	speed = stats.speed
	jump_velocity = stats.jump_velocity
	strength = stats.strength
	max_health = stats.max_health
	max_poison = stats.max_poison
	max_adrenaline = stats.max_adrenaline
	current_health = max_health
	current_adrenaline = max_adrenaline


func _handle_buffs() -> void:
	if buffs & Buff.POISON:
		current_poison -= stats.poison_decay
		if current_poison == 0:
			buffs -= Buff.POISON

	if buffs & Buff.ADRENALINE:
		current_adrenaline -= stats.adrenaline_decay
		if current_adrenaline == 0:
			buffs -= Buff.ADRENALINE
			strength = stats.strength
			speed = stats.speed
			jump_velocity = stats.jump_velocity
			animations.playback_speed = 1
