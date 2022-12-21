class_name Player
extends Entity

enum Buff { POISON = 1, ADRENALINE = 2, ALL = 3 }

signal player_ready
signal poison_changed
signal adrenaline_changed

var direction: float:
	get:
		direction = Input.get_axis("move_left", "move_right")
		if direction > 0: sprite.scale.x = 1
		if direction < 0: sprite.scale.x = -1
		return direction

var stats: Stats = preload("res://resources/stats.gd").new()
#var stats: Stats
#var inventory: Inventory = preload("res://resources/inventory.gd").new()

var max_poison: int:
	get: return stats.max_poison
var max_adrenaline: int:
	get: return stats.max_adrenaline
var current_poison: float = 0:
	set(value):
		current_poison = clamp(value, 0, max_poison)
		emit_signal("poison_changed", current_poison, max_poison)
var current_adrenaline: float = 0:
	set(value):
		current_adrenaline = clamp(value, 0, max_adrenaline)
		emit_signal("adrenaline_changed", current_adrenaline, max_adrenaline)
var buffs: int
var speed: float
var jump_velocity: float
var _rainbow_effect = preload("res://player/materials/adrenaline_buff.tres")
var _ghost_effect = preload("res://player/particles/ghost_effect.tscn")
var _explosion = load("res://player/particles/explosion.tscn")

@onready var attacks: AttackData = $Sprite/Hitbox.data
@onready var camera: Camera2D = $Camera
@onready var _poison_effect: Polygon2D  = $Sprite/PoisonFX
@onready var _poison_particles: CPUParticles2D = $Sprite/PoisonFX/Particles
@onready var _adrenaline_burst: CollisionShape2D = $Sprite/Hitbox2/AdrenalineBurst


func _ready() -> void:
	state_machine.init()
	_init_stats()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)

	# TODO - put buff triggers in states/items
	if Input.is_action_just_pressed("activate_adrenaline") and current_adrenaline == max_adrenaline:
		_activate_adrenaline()

	if Input.is_action_just_pressed("activate_poison"):
		if buffs & Buff.POISON:
			return
		_activate_poison()

	if Input.is_action_just_pressed("restore_hp"):
		_restore_health()


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)
	_handle_buffs()


func _process(delta: float) -> void:
	state_machine.process(delta)


func succesful_hit() -> void:
	current_adrenaline += stats.adrenaline_gain


func _activate_adrenaline() -> void:
	buffs += Buff.ADRENALINE
	strength *= 1.5
	speed *= 1.2
	attacks.regular_stagger = false
	set_material(_rainbow_effect)
	add_child(_explosion.instantiate())
	_adrenaline_burst.disabled = false
	$AdrenalineBurstTimer.start()
	$AdrenalineFXTimer.start()


func _activate_poison() -> void:
	buffs += Buff.POISON
	current_poison += max_poison
	attacks.applies_poison = true
	_toggle_poison_vfx()


func _restore_health() -> void:
	current_health = max_health


func _init_stats() -> void:
	camera.current = true
	speed = stats.speed
	jump_velocity = stats.jump_velocity
	strength = stats.strength
	max_health = stats.max_health
	max_poison = stats.max_poison
	max_adrenaline = stats.max_adrenaline
	current_health = max_health
	current_adrenaline = 0
	current_poison = 0
	buffs -= Buff.POISON
	buffs -= Buff.ADRENALINE

	$Interface/HUD/HealthBar.size.x = max_health * 0.75
	$Interface/HUD/AdrenalineBar.size.x = max_adrenaline * 0.75
	$Interface/HUD/PoisonBar.size.x = max_poison * 0.75


func _handle_buffs() -> void:
	if buffs & Buff.POISON:
		current_poison -= stats.poison_decay
		if current_poison == 0:
			buffs -= Buff.POISON
			attacks.applies_poison = false
			_toggle_poison_vfx()


	if buffs & Buff.ADRENALINE:
		current_adrenaline -= stats.adrenaline_decay
		if current_adrenaline == 0:
			buffs -= Buff.ADRENALINE
			strength = stats.strength
			speed = stats.speed
			attacks.regular_stagger = true
			$AdrenalineFXTimer.stop()
			set_material(null)


func _toggle_poison_vfx() -> void:
	var toggle = !_poison_effect.visible
	var tween = create_tween().set_ease(Tween.EASE_IN)

	if toggle:
		_poison_effect.visible = toggle
		sprite.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
		tween.tween_property(_poison_effect, "self_modulate", Color("ffffff"), 1.0)
		_poison_particles.emitting = toggle
	else:
		_poison_particles.emitting = toggle
		sprite.clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
		tween.tween_property(_poison_effect, "self_modulate", Color("ffffff02"), 1.0)
		_poison_effect.visible = toggle


func _on_adrenalinefx_timer_timeout() -> void:
	var ghost_effect = _ghost_effect.instantiate()
	ghost_effect.texture = sprite.texture
	ghost_effect.scale = sprite.scale
	add_child(ghost_effect)
	$AdrenalineFXTimer.start()


func _on_adrenaline_burst_timer_timeout() -> void:
	_adrenaline_burst.disabled = true
