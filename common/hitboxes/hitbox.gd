class_name Hitbox
extends Area2D

@export_flags_2d_physics var damage_source: int

@onready var damage: int = owner.damage


func _ready() -> void:
	collision_layer = damage_source
	collision_mask = 0
	print(collision_layer)
