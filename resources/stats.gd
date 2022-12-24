class_name Stats
extends Resource

signal resource_stat_changed
signal strength_changed

@export var adrenaline_decay := 0.3
@export var poison_decay := 0.05

@export var max_health: int = 100:
	set(value):
		max_health = value
		emit_signal("resource_stat_changed", "health")
@export var max_adrenaline: int = 100:
	set(value):
		max_adrenaline = value
		emit_signal("resource_stat_changed", "adrenaline")
@export var max_poison: int = 100:
	set(value):
		max_poison = value
		emit_signal("resource_stat_changed", "poison")
@export var adrenaline_gain := 2.0
@export var strength := 10.0:
	set(value):
		strength = value
		emit_signal("strength_changed")
@export var speed := 120.0
@export var jump_velocity := -384.0


func reset_to_default() -> void:
	adrenaline_decay = 0.3
	poison_decay = 0.05
	max_health = 100
	max_adrenaline = 100
	max_poison = 100
	adrenaline_gain = 2.0
	strength = 10.0
	speed = 120.0
	jump_velocity = -384.0
