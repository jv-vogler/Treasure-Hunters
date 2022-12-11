class_name Hurtbox
extends Area2D

signal hit

@export_flags_2d_physics var takes_damage_from: int


func _ready() -> void:
	collision_layer =  0
	collision_mask = takes_damage_from
	connect("area_entered", Callable(self, "_on_area_entered"))


func _on_area_entered(hitbox: Hitbox) -> void:
	if !hitbox:
		return

	if hitbox.owner.is_in_group("Player"):
		hitbox.owner.succesful_hit()

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)

		var direction: float = owner.position.x - hitbox.owner.position.x
		if direction > 0:
			emit_signal("hit", {
				"direction": 1,
				"applies_poison": hitbox.data.applies_poison,
				"knock_intensity": hitbox.data.knock_intensity,
				"knock_height": hitbox.data.knock_height,
				"applies_stagger": hitbox.data.applies_stagger,
				})
		elif direction < 0:
			emit_signal("hit", {
				"direction": -1,
				"applies_poison": hitbox.data.applies_poison,
				"knock_intensity": hitbox.data.knock_intensity,
				"knock_height": hitbox.data.knock_height,
				"applies_stagger": hitbox.data.applies_stagger,
				})
