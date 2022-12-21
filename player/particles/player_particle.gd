class_name PlayerParticle
extends Sprite2D

@export var animation := ""
@export var sprite_offset: Vector2


func _ready() -> void:
	top_level = true
	var _player: Player = get_tree().get_first_node_in_group("Player")
	position = _player.position + sprite_offset
	$AnimationPlayer.play(animation)


func remove() -> void:
	queue_free()
