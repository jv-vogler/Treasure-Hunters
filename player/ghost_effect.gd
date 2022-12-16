extends Sprite2D

var _player: Player = owner


func _ready() -> void:
	position = get_tree().get_nodes_in_group("Player")[0].position
	$Animation.play("Fade")


func remove() -> void:
	queue_free()
