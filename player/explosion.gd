extends Sprite2D


func _ready() -> void:
	position = get_tree().get_nodes_in_group("Player")[0].position - Vector2(12, 12)
	$Animation.play("Explode")


func remove() -> void:
	queue_free()
