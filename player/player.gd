class_name Player
extends Entity

enum Buff { POISON = 1, ADRENALINE = 2, ALL = 3 }

signal poison_changed
signal adrenaline_changed

var direction: float:
	get:
		direction = Input.get_axis("move_left", "move_right")
		if direction > 0: sprite.scale.x = 1
		if direction < 0: sprite.scale.x = -1
		return direction

var stats = GameStateManager.stats
var inventory = GameStateManager.inventory
var current_poison: float = 0:
	set(value):
		current_poison = clamp(value, 0, stats.max_poison)
		emit_signal("poison_changed", current_poison, stats.max_poison)
var current_adrenaline: float = 0:
	set(value):
		current_adrenaline = clamp(value, 0, stats.max_adrenaline)
		emit_signal("adrenaline_changed", current_adrenaline, stats.max_adrenaline)
var current_health: int:
	set(value):
		current_health = clamp(value, 0, stats.max_health)
		emit_signal("health_changed", current_health, stats.max_health)
var strength: float
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
	camera.current = true
	stats.connect("resource_stat_changed", Callable(self, "_on_resource_stat_changed"))
	stats.connect("strength_changed", Callable(self, "_update_strength"))
	_init_stats()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)

	# TODO - put buff triggers in states/items
	if Input.is_action_just_pressed("activate_adrenaline") and current_adrenaline == stats.max_adrenaline:
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


func take_damage(damage) -> void:
	print("%s received %s damage." % [name, damage])
	emit_signal("took_damage")
	current_health -= damage


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
	current_poison += stats.max_poison
	attacks.applies_poison = true
	_toggle_poison_vfx()


func _restore_health() -> void:
	current_health = stats.max_health


func _init_stats() -> void:
	speed = stats.speed
	jump_velocity = stats.jump_velocity
	current_health = stats.max_health
	current_adrenaline = 0
	current_poison = 0
	buffs -= Buff.POISON
	buffs -= Buff.ADRENALINE
	_update_strength()
	_update_bars()


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
			speed = stats.speed
			attacks.regular_stagger = true
			$AdrenalineFXTimer.stop()
			set_material(null)
			_update_strength()


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


func _update_strength() -> void:
	strength = stats.strength


func _update_bars() -> void:
	var bar_scale := 0.75
	var duration := 0.25
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.set_parallel()
	tween.tween_property($Interface/HUD/HealthBar, "size:x", stats.max_health * bar_scale, duration)
	tween.tween_property($Interface/HUD/AdrenalineBar, "size:x", stats.max_adrenaline * bar_scale, duration)
	tween.tween_property($Interface/HUD/PoisonBar, "size:x", stats.max_poison * bar_scale, duration)


func _on_resource_stat_changed(resource: String) -> void:
	_update_bars()
	if resource == "health":
		emit_signal("health_changed", current_health, stats.max_health)
	elif resource == "adrenaline":
		emit_signal("adrenaline_changed", current_adrenaline, stats.max_adrenaline)
	elif resource == "poison":
		emit_signal("poison_changed", current_poison, stats.max_poison)


func _on_adrenalinefx_timer_timeout() -> void:
	var ghost_effect = _ghost_effect.instantiate()
	ghost_effect.texture = sprite.texture
	ghost_effect.scale = sprite.scale
	add_child(ghost_effect)
	$AdrenalineFXTimer.start()


func _on_adrenaline_burst_timer_timeout() -> void:
	_adrenaline_burst.disabled = true
