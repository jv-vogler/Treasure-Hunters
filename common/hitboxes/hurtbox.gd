class_name Hurtbox
extends Area2D

signal hit_direction

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

		var hurtbox_pos: float = get_child(0).global_position.x + owner.global_position.x
		var hitbox_pos: float = hitbox.get_child(0).global_position.x + hitbox.owner.global_position.x

		var direction: float = hurtbox_pos - hitbox_pos
		if direction > 0:
			emit_signal("hit_direction", 1)
		elif direction < 0:
			emit_signal("hit_direction", -1)
