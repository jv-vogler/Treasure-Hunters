class_name Hitbox
extends Area2D

@export_flags_2d_physics var damage_source: int
@export var attack_data: Resource

var attack_strength: int:
	get:
		return owner.strength
var damage: int:
	get:
		return int(attack_strength * randf_range(0.8, 1.2))

@onready var data: AttackData = attack_data


func _ready() -> void:
	collision_layer = damage_source
	collision_mask = 0
