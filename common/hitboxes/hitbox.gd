class_name Hitbox
extends Area2D

@export_flags_2d_physics var damage_source: int

@onready var damage: int = owner.strength #TODO damage formula


func _ready() -> void:
	collision_layer = damage_source
	collision_mask = 0
