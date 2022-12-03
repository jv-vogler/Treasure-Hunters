class_name Hurtbox
extends Area2D

@export_flags_2d_physics var takes_damage_from: int


func _ready() -> void:
	collision_layer =  0
	collision_mask = takes_damage_from
	connect("area_entered", Callable(self, "_on_area_entered"))


func _on_area_entered(hitbox: Hitbox) -> void:
	if !hitbox:
		return

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		owner.emit_signal("took_damage")
