class_name PlayerParticle
extends Sprite2D

@export var animation := ""
@export var sprite_offset: Vector2


func _ready() -> void:
	position = get_tree().get_nodes_in_group("Player")[0].position - sprite_offset
	$Animation.play(animation)


func remove() -> void:
	queue_free()
