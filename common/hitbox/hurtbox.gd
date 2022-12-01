class_name Hurtbox
extends Area2D


func _init() -> void:
	collision_layer = 0
	collision_mask = 2


func _ready() -> void:
	area_entered.connect(self.on_area_entered)


func on_area_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
