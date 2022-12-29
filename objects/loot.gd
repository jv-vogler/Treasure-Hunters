class_name Loot
extends RigidBody2D

@export var item: ItemData

var spread: int = 50
var min_height: int = -100
var max_height: int = -200

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	randomize()
	sprite.texture = item.icon
	var x_force = randi_range(-spread, spread)
	var y_force = randi_range(min_height, max_height)
	var force_position = Vector2(randi_range(-3, 3), randi_range(0, 2))
	apply_force(Vector2(x_force, y_force), force_position)


func collect() -> void:
	GameStateManager.inventory.add_item(item.id, 1)
	queue_free()


func _on_player_entered(player: Player) -> void:
	if !player:
		return
	collect()
